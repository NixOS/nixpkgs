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

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-viHFWONNfBGw9q61CVbAlSC//NArf86cb46FMaQBocg=";
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

<<<<<<< HEAD
  __darwinAllowLocalNetworking = true;

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  nativeCheckInputs = [
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
    changelog = "https://github.com/astropy/pytest-remotedata/blob/v${version}/CHANGES.rst";
    license = licenses.bsd3;
<<<<<<< HEAD
    maintainers = with maintainers; [ ];
=======
    maintainers = with maintainers; [ costrouc ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
