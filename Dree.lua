-- Script Admin Básico para Roblox (Server Script)
-- Coloque este script no ServerScriptService

local Players = game:GetService("Players")

-- ============================================
-- 1. SISTEMA DE KICK POR NOME
-- ============================================

-- Lista de admins (adicione seus nomes aqui)
local admins = {
    "SeuNomeAqui" -- Substitua pelo seu nome de usuário
}

-- Função para verificar se é admin
local function isAdmin(player)
    for _, adminName in pairs(admins) do
        if player.Name == adminName then
            return true
        end
    end
    return false
end

-- Comando para kickar jogador
-- Use no chat: /kick NomeDoJogador
Players.PlayerAdded:Connect(function(player)
    player.Chatted:Connect(function(message)
        if isAdmin(player) then
            local args = string.split(message, " ")
            
            -- Comando /kick
            if args[1]:lower() == "/kick" and args[2] then
                local targetName = args[2]
                local targetPlayer = Players:FindFirstChild(targetName)
                
                if targetPlayer then
                    targetPlayer:Kick("Você foi removido do servidor por um administrador.")
                    print(player.Name .. " kickou " .. targetName)
                else
                    print("Jogador não encontrado: " .. targetName)
                end
            end
        end
    end)
end)

-- ============================================
-- 2. ESP DE PLAYERS (Local Script)
-- ============================================
-- Coloque este código em um LocalScript no StarterPlayerScripts

--[[
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local espEnabled = false
local espBoxes = {}

-- Função para criar ESP
local function createESP(player)
    if player == LocalPlayer then return end
    
    local box = Instance.new("BoxHandleAdornment")
    box.Size = Vector3.new(4, 6, 4)
    box.Color3 = Color3.fromRGB(255, 0, 0)
    box.Transparency = 0.7
    box.AlwaysOnTop = true
    box.ZIndex = 10
    box.Adornee = nil
    box.Parent = game.CoreGui
    
    local nameTag = Instance.new("BillboardGui")
    nameTag.Size = UDim2.new(0, 200, 0, 50)
    nameTag.AlwaysOnTop = true
    nameTag.Parent = game.CoreGui
    
    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = player.Name
    textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    textLabel.TextStrokeTransparency = 0.5
    textLabel.Font = Enum.Font.SourceSansBold
    textLabel.TextSize = 16
    textLabel.Parent = nameTag
    
    espBoxes[player] = {box = box, nameTag = nameTag}
end

-- Atualizar ESP
RunService.RenderStepped:Connect(function()
    if not espEnabled then return end
    
    for player, esp in pairs(espBoxes) do
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = player.Character.HumanoidRootPart
            esp.box.Adornee = hrp
            esp.nameTag.Adornee = hrp
        else
            esp.box.Adornee = nil
            esp.nameTag.Adornee = nil
        end
    end
end)

-- Toggle ESP com tecla E
local UserInputService = game:GetService("UserInputService")
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.E then
        espEnabled = not espEnabled
        
        if espEnabled then
            print("ESP de Players ATIVADO")
            for _, player in pairs(Players:GetPlayers()) do
                createESP(player)
            end
        else
            print("ESP de Players DESATIVADO")
            for _, esp in pairs(espBoxes) do
                esp.box:Destroy()
                esp.nameTag:Destroy()
            end
            espBoxes = {}
        end
    end
end)

-- Criar ESP para novos jogadores
Players.PlayerAdded:Connect(function(player)
    if espEnabled then
        createESP(player)
    end
end)

-- Remover ESP quando jogador sair
Players.PlayerRemoving:Connect(function(player)
    if espBoxes[player] then
        espBoxes[player].box:Destroy()
        espBoxes[player].nameTag:Destroy()
        espBoxes[player] = nil
    end
end)
]]

-- ============================================
-- 3. ESP DE FRUTAS (Local Script)
-- ============================================
-- Coloque este código em um LocalScript no StarterPlayerScripts

--[[
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

local fruitESPEnabled = false
local fruitBoxes = {}

-- Nomes comuns de frutas em jogos de Roblox (ajuste conforme seu jogo)
local fruitNames = {"Fruit", "Devil Fruit", "Blox Fruit"}

-- Função para verificar se é uma fruta
local function isFruit(obj)
    for _, name in pairs(fruitNames) do
        if string.find(obj.Name:lower(), name:lower()) then
            return true
        end
    end
    return false
end

-- Criar ESP para fruta
local function createFruitESP(fruit)
    local box = Instance.new("BoxHandleAdornment")
    box.Size = fruit.Size + Vector3.new(0.5, 0.5, 0.5)
    box.Color3 = Color3.fromRGB(255, 255, 0)
    box.Transparency = 0.5
    box.AlwaysOnTop = true
    box.ZIndex = 10
    box.Adornee = fruit
    box.Parent = game.CoreGui
    
    fruitBoxes[fruit] = box
end

-- Toggle Fruit ESP com tecla F
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.F then
        fruitESPEnabled = not fruitESPEnabled
        
        if fruitESPEnabled then
            print("ESP de Frutas ATIVADO")
            for _, obj in pairs(Workspace:GetDescendants()) do
                if obj:IsA("BasePart") and isFruit(obj) then
