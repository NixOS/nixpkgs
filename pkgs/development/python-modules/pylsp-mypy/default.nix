{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  mypy,
  pytestCheckHook,
  python-lsp-server,
  pythonOlder,
  tomli,
}:

buildPythonPackage rec {
  pname = "pylsp-mypy";
  version = "0.6.8";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "python-lsp";
    repo = "pylsp-mypy";
    rev = "refs/tags/${version}";
    hash = "sha256-oEWUXkE8U7/ye6puJZRSkQFi10BPGuc8XZQbHwqOPEI=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
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

  meta = with lib; {
    description = "Mypy plugin for the Python LSP Server";
    homepage = "https://github.com/python-lsp/pylsp-mypy";
    license = licenses.mit;
    maintainers = with maintainers; [ cpcloud ];
  };
}
