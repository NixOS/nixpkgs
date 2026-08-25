{
  lib,
  fetchFromGitHub,
  dotnetCorePackages,
  buildDotnetModule,
  nix-update-script,
  versionCheckHook,
}:
buildDotnetModule rec {
  pname = "undertalemodcli";
  version = "0.9.2.0";
  src = fetchFromGitHub {
    owner = "UnderminersTeam";
    repo = "UndertaleModTool";
    tag = version;
    sha256 = "sha256-bNSIU5SdyvFqDt1a63NUIuBWRxzk4bNYALSrCku6Cvg=";
    fetchSubmodules = true;
  };
  projectFile = "UndertaleModCli";

  doCheck = true;
  testProjectFile = [
    "UndertaleModLibTests"
    "Underanalyzer/UnderanalyzerTest"
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  strictDeps = true;
  __structuredAttrs = true;

  # generated via: $(nix-build -A undertalemodcli.fetch-deps)
  nugetDeps = ./deps.json;

  dotnet-sdk = dotnetCorePackages.sdk_10_0;
  dotnet-runtime = dotnetCorePackages.runtime_10_0;
  executables = [ "UndertaleModCli" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://underminersteam.github.io/";
    description = "CLI tool for modding, decompiling and unpacking GameMaker games";
    changelog = "https://github.com/UnderminersTeam/UndertaleModTool/releases/tag/${version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ skirlez ];
    platforms = with lib.platforms; (lib.intersectLists x86_64 (linux ++ windows)) ++ darwin;
    mainProgram = "UndertaleModCli";
  };
}
