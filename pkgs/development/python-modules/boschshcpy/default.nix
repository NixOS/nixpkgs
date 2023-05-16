{ lib
, buildPythonPackage
, cryptography
, fetchFromGitHub
, getmac
, pythonOlder
, requests
, zeroconf
}:

buildPythonPackage rec {
  pname = "boschshcpy";
<<<<<<< HEAD
  version = "0.2.67";
=======
  version = "0.2.57";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "tschamm";
    repo = pname;
    rev = version;
<<<<<<< HEAD
    hash = "sha256-M0LyEKJUcamv0PcflVI97zrXAoe1iV5sJ/oh60bMo6c=";
=======
    hash = "sha256-/TD5zvvtOkoVG+EJzNNSMbOKXm78Di9tDrBIxpN4wbg=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    cryptography
    getmac
    requests
    zeroconf
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [
    "boschshcpy"
  ];

  meta = with lib; {
    description = "Python module to work with the Bosch Smart Home Controller API";
    homepage = "https://github.com/tschamm/boschshcpy";
    license = with licenses; [ bsd3 ];
    maintainers = with maintainers; [ fab ];
  };
}
