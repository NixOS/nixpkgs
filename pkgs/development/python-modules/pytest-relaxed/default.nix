{ lib
, buildPythonPackage
, decorator
, fetchPypi
, invocations
, invoke
, pytest
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pytest-relaxed";
<<<<<<< HEAD
  version = "2.0.1";
=======
  version = "2.0.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-U6c3Lj/qpSdAm7QDU/gTxZt2Dl2L1H5vb88YfF2W3Qw=";
=======
    hash = "sha256-Szc8x1Rmb/YPVCWmnLQUZCwqEc56RsjOBmpzjkCSyjk=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  buildInputs = [
    pytest
  ];

  propagatedBuildInputs = [
    decorator
  ];

  nativeCheckInputs = [
    invocations
    invoke
    pytestCheckHook
  ];

  pytestFlagsArray = [
    "tests"
  ];

  pythonImportsCheck = [
    "pytest_relaxed"
  ];

  meta = with lib; {
    homepage = "https://pytest-relaxed.readthedocs.io/";
    description = "Relaxed test discovery/organization for pytest";
    changelog = "https://github.com/bitprophet/pytest-relaxed/blob/${version}/docs/changelog.rst";
    license = licenses.bsd0;
<<<<<<< HEAD
    maintainers = with maintainers; [ ];
=======
    maintainers = with maintainers; [ costrouc ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
