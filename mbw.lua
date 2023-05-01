local Modules = {
    File = "ServerHop.json" ,
    List = {} 
} ;
local HopStart = false ;
local HttpService = game:GetService("HttpService")

function Modules.SaveSetting() 
    if not isfolder("Private") then 
       makefolder("Private") ;     
    end
    return writefile("Private/"..Modules.File,game:GetService("HttpService"):JSONEncode(Modules))  ;
end ;

function Modules.LoadSetting() 
    if not isfolder("Private") then 
       makefolder("Private") ;     
    end
    if not pcall(function() readfile("Private/"..Modules.File) end) then
        writefile("Private/"..Modules.File,game:GetService("HttpService"):JSONEncode({Modules.List})) ;
        return HttpService:JSONDecode(readfile("Private/"..Modules.List))  ;
    end
    return HttpService:JSONDecode(readfile("Private/"..Modules.File))  ; 
end ;


local Load = Modules.LoadSetting() 

function Modules.HopServer() 
    for i = 1 , 100 do 

        local Servers = game:GetService("ReplicatedStorage").__ServerBrowser:InvokeServer(i) ;

        if type(Servers) ~= "table" then continue end 

        for jobid ,v in pairs(Servers) do 
            if jobid == game.JobId or v.Count < 10 or Load[jobid] then continue end ;

            Load[jobid] = true ;

            Modules.SaveSetting() ;

            return game:GetService("ReplicatedStorage").__ServerBrowser:InvokeServer("teleport",jobid) ;

        end ;

    end ;
end ;

function Modules.new() 
    while true do task.wait() 
        if HopStart then continue end 
        HopStart = true ;
        local Error = game.CoreGui.RobloxPromptGui.promptOverlay:FindFirstChild("ErrorPrompt") ;
         Modules.HopServer()
--         if not Error or ( Error and Error.TitleFrame.ErrorTitle.Text == "Teleport Failed" ) then 
--             Modules.HopServer()
--         else
--             continue
--         end ;
    end ;
end ;

return Modules ;
