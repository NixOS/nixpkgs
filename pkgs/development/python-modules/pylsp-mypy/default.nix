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
  version = "0.7.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "python-lsp";
    repo = "pylsp-mypy";
    tag = version;
    hash = "sha256-rS0toZaAygNJ3oe3vfP9rKJ1A0avIdp5yjNx7oGOB4o=";
  };

  build-system = [ setuptools ];

  dependencies = [
    mypy
    python-lsp-server
  ]
  ++ lib.optional (pythonOlder "3.11") tomli;

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
