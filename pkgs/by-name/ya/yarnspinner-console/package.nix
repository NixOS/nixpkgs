{
  buildDotnetModule,
  dotnetCorePackages,
  fetchFromGitHub,
  lib,
  nix-update-script,
}:
buildDotnetModule (finalAttrs: {
  pname = "yarnspinner-console";
  version = "3.2.2";

  src = fetchFromGitHub {
    owner = "YarnSpinnerTool";
    repo = "YarnSpinner-Console";
    rev = "v${finalAttrs.version}";
    hash = "sha256-2MEJAdg08wmseiXnA66oSyuZn8s6l6sE/3qxm7Zd50s=";
  };

  __structuredAttrs = true;
  strictDeps = true;

  dotnet-sdk = dotnetCorePackages.sdk_9_0;
  dotnet-runtime = dotnetCorePackages.runtime_9_0;
  projectFile = "src/YarnSpinner.Console/ysc.csproj";
  nugetDeps = ./deps.json;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "The command line tool for working with Yarn Spinner";
    homepage = "https://github.com/YarnSpinnerTool/YarnSpinner-Console";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    mainProgram = "ysc";
    maintainers = with lib.maintainers; [ musjj ];
  };
})
