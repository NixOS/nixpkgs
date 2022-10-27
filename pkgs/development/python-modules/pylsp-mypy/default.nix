{ lib
, buildPythonPackage
, fetchFromGitHub
, mock
, mypy
, pytestCheckHook
, python-lsp-server
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pylsp-mypy";
  version = "0.6.3";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "Richardk2n";
    repo = "pylsp-mypy";
    rev = "refs/tags/${version}";
    sha256 = "sha256-fZ2bPPjBK/H2jMI4S3EhvWJaNl4tK7HstxcHSAkoFW4=";
  };

  disabledTests = [
    "test_multiple_workspaces"
    "test_option_overrides_dmypy"
  ];

  checkInputs = [ pytestCheckHook mock ];

  propagatedBuildInputs = [ mypy python-lsp-server ];

  pythonImportsCheck = [ "pylsp_mypy" ];

  meta = with lib; {
    homepage = "https://github.com/Richardk2n/pylsp-mypy";
    description = "Mypy plugin for the Python LSP Server";
    license = licenses.mit;
    maintainers = with maintainers; [ cpcloud ];
  };
}
