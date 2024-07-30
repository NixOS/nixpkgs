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
  version = "0.6.8";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "python-lsp";
    repo = "pylsp-mypy";
    rev = "refs/tags/${version}";
    hash = "sha256-oEWUXkE8U7/ye6puJZRSkQFi10BPGuc8XZQbHwqOPEI=";
  };

  build-system = [ setuptools ];

  dependencies = [
    mypy
    python-lsp-server
    tomli
  ];

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
