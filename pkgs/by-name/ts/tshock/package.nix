{
  lib,
  fetchFromGitHub,
  buildDotnetModule,
  dotnet-sdk_6,
  dotnet-runtime_6,
}:
buildDotnetModule rec {
  pname = "tshock";
  version = "5.2.4";

  src = fetchFromGitHub {
    owner = "Pryaxis";
    repo = "TShock";
    rev = "v${version}";
    sha256 = "sha256-dQ4yux5k4K1t6ah9r4X6d1KPAMqzzCsGvBKhm0TYIjA=";
    fetchSubmodules = true;
  };

  dotnet-sdk = dotnet-sdk_6;
  dotnet-runtime = dotnet-runtime_6;
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

  meta = {
    homepage = "https://github.com/Pryaxis/TShock";
    description = "Modded server software for Terraria, providing a plugin system and inbuilt tools such as anti-cheat, server-side characters, groups, permissions, and item bans";
    license = lib.licenses.gpl3Only;
    maintainers = [ lib.maintainers.proggerx ];
    mainProgram = "TShock.Server";
  };
}
