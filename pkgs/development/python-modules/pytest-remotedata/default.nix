{ lib
, buildPythonPackage
, fetchPypi
, pytest
, pytestCheckHook
, pythonOlder
, setuptools-scm
, six
}:

buildPythonPackage rec {
  pname = "pytest-remotedata";
  version = "0.4.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-viHFWONNfBGw9q61CVbAlSC//NArf86cb46FMaQBocg=";
  };

  nativeBuildInputs = [
    setuptools-scm
  ];

  buildInputs = [
    pytest
  ];

  propagatedBuildInputs = [
    six
  ];

  checkInputs = [
    pytestCheckHook
  ];

  disabledTestPaths = [
    # These tests require a network connection
    "tests/test_strict_check.py"
  ];

  pythonImportsCheck = [
    "pytest_remotedata"
  ];

  meta = with lib; {
    description = "Pytest plugin for controlling remote data access";
    homepage = "https://github.com/astropy/pytest-remotedata";
    license = licenses.bsd3;
    maintainers = with maintainers; [ costrouc ];
  };
}
