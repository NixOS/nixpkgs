{ lib
, buildPythonPackage
, fetchPypi
, pytest
, pytest-asyncio
, pytestCheckHook
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "pytest-mock";
  version = "3.8.1";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-LG11bV07+Y4ugHl6lZyn+B9Hnn0fX1cWEbD91tF0UkA=";
  };

  nativeBuildInputs = [ setuptools-scm ];

  propagatedBuildInputs = [
    pytest
  ];

  checkInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  disabledTests = [
    # output of pytest has changed
    "test_used_with_"
    "test_plain_stopall"
  ];

  pythonImportsCheck = [ "pytest_mock" ];

  meta = with lib; {
    description = "Thin-wrapper around the mock package for easier use with pytest";
    homepage = "https://github.com/pytest-dev/pytest-mock";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ dotlambda ];
  };
}
