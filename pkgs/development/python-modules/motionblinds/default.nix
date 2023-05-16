{ lib
, buildPythonPackage
, fetchFromGitHub
, pycryptodomex
, pythonOlder
}:

buildPythonPackage rec {
  pname = "motionblinds";
<<<<<<< HEAD
  version = "0.6.18";
=======
  version = "0.6.17";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "starkillerOG";
    repo = "motion-blinds";
    rev = "refs/tags/${version}";
<<<<<<< HEAD
    hash = "sha256-EkHrBhlPlavF6qbTF9myDBYh5eHxiZ4OoDzvlSs/LYM=";
=======
    hash = "sha256-rCPwOhhv1hDwJqs8g3JfXcSgvrLf6UhNm0JPtRGW5S0=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    pycryptodomex
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [
    "motionblinds"
  ];

  meta = with lib; {
    description = "Python library for interfacing with Motion Blinds";
    homepage = "https://github.com/starkillerOG/motion-blinds";
    changelog = "https://github.com/starkillerOG/motion-blinds/releases/tag/${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
