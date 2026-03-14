{
  lib,
  fetchFromGitHub,
  dotnetCorePackages,
  buildDotnetModule,
}:
buildDotnetModule rec {
  pname = "undertalemodcli";
  version = "0.8.4.1";
  src = fetchFromGitHub {
    owner = "UnderminersTeam";
    repo = "UndertaleModTool";
    rev = "19845f24a37655d9615295ae33191ca76e6bffe8";
    sha256 = "sha256-ARvQ0u+v3zBN6rp9OsCzabYWPOy/E0HI1hAj9H88ZiY=";
    fetchSubmodules = true;
  };
  projectFile = "UndertaleModCli";

  doCheck = true;
  testProjectFile = [
    "UndertaleModLibTests"
    "Underanalyzer/UnderanalyzerTest"
  ];

  # generated via
  # nix-build -A undertalemodcli.fetch-deps
  nugetDeps = ./deps.json;

  dotnet-sdk = dotnetCorePackages.sdk_10_0;
  dotnet-runtime = dotnetCorePackages.runtime_10_0;
  executables = [ "UndertaleModCli" ];

  meta = {
    homepage = "https://underminersteam.github.io/";
    description = "CLI tool for modding, decompiling and unpacking GameMaker games";
    changelog = "https://github.com/UnderminersTeam/UndertaleModTool/releases/tag/${version}";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ skirlez ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "UndertaleModCli";
  };
}
