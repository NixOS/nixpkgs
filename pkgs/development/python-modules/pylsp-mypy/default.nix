{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  mypy,
  pytestCheckHook,
  python-lsp-server,
  tomli,
}:

buildPythonPackage rec {
  pname = "pylsp-mypy";
  version = "0.6.9";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "python-lsp";
    repo = "pylsp-mypy";
    rev = "refs/tags/${version}";
    hash = "sha256-MP9a8dI5ggM+XEJYB6O4nYDYIXbtxi2TK5b+JQgViZQ=";
  };

  build-system = [ setuptools ];

  dependencies = [
    mypy
    python-lsp-server
  ] ++ lib.optional (pythonOlder "3.11") tomli;

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pylsp_mypy" ];

  disabledTests = [
    # Tests wants to call dmypy
    "test_option_overrides_dmypy"
  ];

  meta = {
    description = "Mypy plugin for the Python LSP Server";
    homepage = "https://github.com/python-lsp/pylsp-mypy";
    changelog = "https://github.com/python-lsp/pylsp-mypy/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ cpcloud ];
  };
}
