{ lib
, aiohttp
, async-timeout
, buildPythonPackage
<<<<<<< HEAD
=======
, cryptography
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, fetchFromGitHub
, pythonOlder
}:

buildPythonPackage rec {
  pname = "millheater";
<<<<<<< HEAD
  version = "0.11.2";
  format = "setuptools";

  disabled = pythonOlder "3.10";
=======
  version = "0.10.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "Danielhiversen";
    repo = "pymill";
<<<<<<< HEAD
    rev = "refs/tags/${version}";
    hash = "sha256-PsNT/mZ4Dun4s9QpGRyEuVxYcM5AXaUS28UsSOowOb4=";
=======
    rev = version;
    hash = "sha256-ImEg+VEiASQPnMeZzbYMMb+ZgcsxagQcN9IDFGO05Vw=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    aiohttp
    async-timeout
<<<<<<< HEAD
=======
    cryptography
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [
    "mill"
  ];

  meta = with lib; {
    description = "Python library for Mill heater devices";
    homepage = "https://github.com/Danielhiversen/pymill";
<<<<<<< HEAD
    changelog = "https://github.com/Danielhiversen/pymill/releases/tag/${version}";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
