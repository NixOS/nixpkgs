{
  lib,
  fetchFromGitHub,
  buildDotnetModule,
  dotnet-sdk_9,
  dotnet-runtime_9,
  nix-update-script,
}:
buildDotnetModule rec {
  pname = "tshock";
  version = "6.1.0";

  src = fetchFromGitHub {
    owner = "Pryaxis";
    repo = "TShock";
    rev = "v${version}";
    hash = "sha256-s6v/OUZmU0/kOH83N7xnurXdAtf49q/X69XWcKrKi/c=";
    fetchSubmodules = true;
  };

  dotnet-sdk = dotnet-sdk_9;
  dotnet-runtime = dotnet-runtime_9;
  executables = [ "TShock.Server" ];

  projectFile = [
    "TShockAPI/TShockAPI.csproj"
    "TerrariaServerAPI/TerrariaServerAPI/TerrariaServerAPI.csproj"
    "TShockLauncher/TShockLauncher.csproj"
    "TShockInstaller/TShockInstaller.csproj"
    "TShockPluginManager/TShockPluginManager.csproj"
  ]; # Excluding tests because they can't build for some reason

  doCheck = false; # The same.

  nugetSource = "https://api.nuget.org/v3/index.json";
  nugetDeps = ./deps.json;

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/Pryaxis/TShock";
    description = "Modded server software for Terraria, providing a plugin system and inbuilt tools such as anti-cheat, server-side characters, groups, permissions, and item bans";
    license = lib.licenses.gpl3Only;
    maintainers = [ lib.maintainers.proggerx ];
    mainProgram = "TShock.Server";
  };
}
