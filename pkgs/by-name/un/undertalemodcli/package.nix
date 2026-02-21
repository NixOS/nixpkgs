{
  lib,
  fetchFromGitHub,
  dotnetCorePackages,
  buildDotnetModule,
}:
buildDotnetModule rec {
  pname = "undertalemodcli";
  version = "0.9.1.1";
  src = fetchFromGitHub {
    owner = "UnderminersTeam";
    repo = "UndertaleModTool";
    rev = version;
    sha256 = "sha256-FGEC0uLaKlBYB76xmzgNMLNMgmAQbQDrLbix4Me3oQE=";
    fetchSubmodules = true;
  };
  projectFile = "UndertaleModCli";

  doCheck = true;
  testProjectFile = [
    "UndertaleModLibTests"
    "Underanalyzer/UnderanalyzerTest"
  ];

  strictDeps = true;
  __structuredAttrs = true;

  # generated via
  # nix-build -A undertalemodcli.fetch-deps
  # ./result
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
