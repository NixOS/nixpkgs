{
  lib,
  python3Packages,
  fetchFromGitHub,
  addBinToPathHook,
  versionCheckHook,
}:

python3Packages.buildPythonApplication rec {
  pname = "tclint";
  version = "0.6.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "nmoroze";
    repo = "tclint";
    tag = "v${version}";
    hash = "sha256-z0ytMK3xxqXZJTMuY2wiBFo8LXAUZZBb13kr/kXtyjI=";
  };

  build-system = with python3Packages; [
    setuptools
    setuptools-scm
  ];

  pythonRelaxDeps = [
    "importlib-metadata"
    "pathspec"
  ];
  dependencies = with python3Packages; [
    importlib-metadata
    pathspec
    ply
    pygls_1
    lsprotocol_2023
    tomli
    voluptuous
  ];

  pythonImportsCheck = [ "tclint" ];

  nativeCheckInputs = [
    addBinToPathHook
    python3Packages.pytestCheckHook
    versionCheckHook
  ];
  versionCheckProgramArg = "--version";

  disabledTestPaths = [
    # Fails to find lsprotocol in the sandbox, even when added to nativeCheckInputs
    # RuntimeError: Client has been stopped.
    # Captured stderr call: ModuleNotFoundError: No module named 'lsprotocol'
    "tests/test_tclsp.py"
  ];

  meta = {
    description = "Modern dev tools for Tcl. Includes a linter, formatter, and editor integration";
    homepage = "https://github.com/nmoroze/tclint";
    changelog = "https://github.com/nmoroze/tclint/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ GaetanLepage ];
    mainProgram = "tclint";
  };
}
