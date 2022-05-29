{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pytest
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pytest-test-utils";
  version = "0.0.6";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "iterative";
    repo = pname;
    rev = version;
    hash = "sha256-0lShdMNP2suN+JO0uKWwjsGQxFCRnCZEQp2h9hQNrrA=";
  };

  buildInputs = [
    pytest
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "pytest_test_utils"
  ];

  meta = with lib; {
    description = "Pytest utilities for tests";
    homepage = "https://github.com/iterative/pytest-test-utils";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
