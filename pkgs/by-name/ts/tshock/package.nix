{
  lib,
  fetchFromGitHub,
  buildDotnetModule,
  dotnet-sdk_6,
  dotnet-runtime_6,
}:
buildDotnetModule rec {
  pname = "tshock";
<<<<<<< HEAD
  version = "5.2.4";
=======
  version = "5.2.3";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "Pryaxis";
    repo = "TShock";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-dQ4yux5k4K1t6ah9r4X6d1KPAMqzzCsGvBKhm0TYIjA=";
=======
    sha256 = "sha256-1EtHpBZ7bbwVbl+tMfwpjgPuxu98XKvxlZ2+SbUlWV4=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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

<<<<<<< HEAD
  meta = {
    homepage = "https://github.com/Pryaxis/TShock";
    description = "Modded server software for Terraria, providing a plugin system and inbuilt tools such as anti-cheat, server-side characters, groups, permissions, and item bans";
    license = lib.licenses.gpl3Only;
    maintainers = [ lib.maintainers.proggerx ];
=======
  meta = with lib; {
    homepage = "https://github.com/Pryaxis/TShock";
    description = "Modded server software for Terraria, providing a plugin system and inbuilt tools such as anti-cheat, server-side characters, groups, permissions, and item bans";
    license = licenses.gpl3Only;
    maintainers = [ maintainers.proggerx ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "TShock.Server";
  };
}
