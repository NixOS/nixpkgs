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
  version = "3.7.0";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-URK9ksyfGG7pbhqS78hJaepJSTnDrq05xQ9CHEzGlTQ=";
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
