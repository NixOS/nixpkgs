{ lib
<<<<<<< HEAD
, aiohttp
, buildPythonPackage
, fetchFromGitHub
, geopy
, pythonOlder
, requests
, setuptools
, urllib3
, wheel
=======
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, geopy
, requests
, urllib3
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonPackage rec {
  pname = "aemet-opendata";
<<<<<<< HEAD
  version = "0.4.4";
  format = "pyproject";

  disabled = pythonOlder "3.11";
=======
  version = "0.2.2";

  disabled = pythonOlder "3.6";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "Noltari";
    repo = "AEMET-OpenData";
    rev = "refs/tags/${version}";
<<<<<<< HEAD
    hash = "sha256-Jm7fv1fNavp2GkfKPhZXYGnGuCBy6BdN9iTNYTBIyew=";
  };

  nativeBuildInputs = [
    setuptools
    wheel
  ];

  propagatedBuildInputs = [
    aiohttp
=======
    hash = "sha256-3f3hvui00oItu6t9rKecoCquqsD1Eeqz+SEsLBqGt48=";
  };

  propagatedBuildInputs = [
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    geopy
    requests
    urllib3
  ];

  # no tests implemented
  doCheck = false;

<<<<<<< HEAD
  pythonImportsCheck = [
    "aemet_opendata.interface"
  ];
=======
  pythonImportsCheck = [ "aemet_opendata.interface" ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "Python client for AEMET OpenData Rest API";
    homepage = "https://github.com/Noltari/AEMET-OpenData";
<<<<<<< HEAD
    changelog = "https://github.com/Noltari/AEMET-OpenData/releases/tag/${version}";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ dotlambda ];
  };
}
