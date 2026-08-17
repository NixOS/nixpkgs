{
  lib,
  fetchFromGitHub,
  gitMinimal,
  gitSetupHook,
  python3Packages,
  writableTmpDirAsHomeHook,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "tbump";
  version = "6.11.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "your-tools";
    repo = "tbump";
    tag = "v${finalAttrs.version}";
    hash = "sha256-+H4C4q+/QlYFgz9hvDZhKtREpa8yN1xLx99odSI3WlY=";
  };

  pythonRelaxDeps = [ "tomlkit" ];

  build-system = with python3Packages; [ poetry-core ];

  dependencies = with python3Packages; [
    docopt
    schema
    packaging
    poetry-core
    tomlkit
    cli-ui
  ];

  nativeCheckInputs = with python3Packages; [
    gitMinimal
    gitSetupHook
    pytest-mock
    pytestCheckHook
    writableTmpDirAsHomeHook
  ];

  meta = {
    description = "Bump software releases";
    homepage = "https://github.com/your-tools/tbump";
    changelog = "https://github.com/your-tools/tbump/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.bsd3;
    mainProgram = "tbump";
    maintainers = with lib.maintainers; [ slashformotion ];
  };
})
