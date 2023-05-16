{ lib
, aiohttp
, async-timeout
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
}:

buildPythonPackage rec {
  pname = "adax";
<<<<<<< HEAD
  version = "0.3.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";
=======
  version = "0.2.0";
  format = "setuptools";

  disabled = pythonOlder "3.5";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "Danielhiversen";
    repo = "pyadax";
<<<<<<< HEAD
    rev = "refs/tags/${version}";
    hash = "sha256-y4c1RBy/UxmKP7+mHXi86XJ2/RXGrqkj94I2Q699EJU=";
=======
    rev = version;
    hash = "sha256-EMSX2acklwWOYiEeLHYG5mwdiGnWAUo5dGMiHCmZrko=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    aiohttp
    async-timeout
  ];

  # Project has no tests
  doCheck = false;

<<<<<<< HEAD
  pythonImportsCheck = [
    "adax"
  ];
=======
  pythonImportsCheck = [ "adax" ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "Python module to communicate with Adax";
    homepage = "https://github.com/Danielhiversen/pyAdax";
<<<<<<< HEAD
    changelog = "https://github.com/Danielhiversen/pyAdax/releases/tag/${version}";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
