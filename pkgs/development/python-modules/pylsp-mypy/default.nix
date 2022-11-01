{ lib
, buildPythonPackage
, fetchFromGitHub
, mypy
, pytestCheckHook
, python-lsp-server
, pythonOlder
, toml
}:

buildPythonPackage rec {
  pname = "pylsp-mypy";
  version = "0.6.3";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "Richardk2n";
    repo = "pylsp-mypy";
    rev = "refs/tags/${version}";
    hash = "sha256-fZ2bPPjBK/H2jMI4S3EhvWJaNl4tK7HstxcHSAkoFW4=";
  };

  propagatedBuildInputs = [
    mypy
    python-lsp-server
    toml
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "pylsp_mypy"
  ];

  disabledTests = [
    # Tests wants to call dmypy
    "test_option_overrides_dmypy"
  ];

  meta = with lib; {
    description = "Mypy plugin for the Python LSP Server";
    homepage = "https://github.com/Richardk2n/pylsp-mypy";
    license = licenses.mit;
    maintainers = with maintainers; [ cpcloud ];
  };
}
