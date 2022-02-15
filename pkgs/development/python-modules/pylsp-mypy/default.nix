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
  version = "0.5.7";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "Richardk2n";
    repo = "pylsp-mypy";
    rev = version;
    sha256 = "0am16z9kmj57r5pi32jhzlbdngzmvzzaiqjm7cba1izh7w5m6dvc";
  };

  disabledTests = [
    "test_multiple_workspaces"
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
