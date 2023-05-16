{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
, regex
<<<<<<< HEAD
, requests
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonPackage rec {
  pname = "iocextract";
<<<<<<< HEAD
  version = "1.16.0";
=======
  version = "1.15.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "InQuest";
    repo = "python-iocextract";
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-jwMu4G146FpH6aFCiZK9tI/3CKnZYC2RCtO9QXXaquQ=";
=======
    hash = "sha256-l0TGi3Y3/Dcwyp80eRWYYlDaDDJdpc31fcxdYEVvQas=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    regex
<<<<<<< HEAD
    requests
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "iocextract"
  ];

  pytestFlagsArray = [
    "tests.py"
  ];

<<<<<<< HEAD
  disabledTests = [
    # AssertionError: 'http://exampledotcom/test' != 'http://example.com/test'
    "test_refang_data"
  ];

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  meta = with lib; {
    description = "Module to extract Indicator of Compromises (IOC)";
    homepage = "https://github.com/InQuest/python-iocextract";
    changelog = "https://github.com/InQuest/python-iocextract/releases/tag/v${version}";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ fab ];
  };
}
