{
  lib,
  python3Packages,
  fetchFromGitHub,
  versionCheckHook,
}:

python3Packages.buildPythonApplication rec {
  pname = "tclint";
  version = "0.6.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "nmoroze";
    repo = "tclint";
    tag = "v${version}";
    hash = "sha256-4aZ4zuAxQ8iC4kox0n1dADuv6Uc/guWsjDa8pI42h8A=";
  };

  build-system = with python3Packages; [
    setuptools
    setuptools-scm
  ];

  pythonRelaxDeps = [
    "importlib-metadata"
    "pathspec"
    "pygls"
  ];
  dependencies = with python3Packages; [
    importlib-metadata
    pathspec
    ply
    pygls
    tomli
    voluptuous
  ];

  pythonImportsCheck = [ "tclint" ];

  preCheck = ''
    rm -rf tclint
  '';

  nativeCheckInputs = [
    python3Packages.lsprotocol
    python3Packages.pytest-lsp
    python3Packages.pytestCheckHook
    versionCheckHook
  ];
  versionCheckProgramArg = "--version";

  meta = {
    description = "Modern dev tools for Tcl. Includes a linter, formatter, and editor integration";
    homepage = "https://github.com/nmoroze/tclint";
    changelog = "https://github.com/nmoroze/tclint/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ GaetanLepage ];
    mainProgram = "tclint";
  };
}
