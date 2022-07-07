{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pytest
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pytest-test-utils";
  version = "0.0.7";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "iterative";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-z5kCFJ8jDzEIUWDjru5vKlZErUvK1iy0WokrCKsvVQo=";
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
