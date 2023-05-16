{ lib
, buildPythonPackage
, fetchPypi
, pytest
, pytestCheckHook
, pexpect
<<<<<<< HEAD
=======
, pytest-cov
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonPackage rec {
  pname = "pytest-timeout";
  version = "2.1.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-wHygdATGEvirviIpSyPDaOLlEEtSHBeQGVVh834aw9k=";
  };

  buildInputs = [
    pytest
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pexpect
<<<<<<< HEAD
=======
    pytest-cov
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  disabledTests = [
    "test_suppresses_timeout_when_pdb_is_entered"
    # Remove until https://github.com/pytest-dev/pytest/pull/7207 or similar
    "test_suppresses_timeout_when_debugger_is_entered"
  ];

  pytestFlagsArray = [
    "-ra"
  ];

  pythonImportsCheck = [
    "pytest_timeout"
  ];

  meta = with lib; {
    description = "Pytest plugin to abort hanging tests";
    homepage = "https://github.com/pytest-dev/pytest-timeout/";
    changelog = "https://github.com/pytest-dev/pytest-timeout/#changelog";
    license = licenses.mit;
<<<<<<< HEAD
    maintainers = with maintainers; [ makefu ];
=======
    maintainers = with maintainers; [ makefu costrouc ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
