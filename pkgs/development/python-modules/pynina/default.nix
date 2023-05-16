{ lib
, aiohttp
, buildPythonPackage
, fetchPypi
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pynina";
<<<<<<< HEAD
  version = "0.3.2";
=======
  version = "0.3.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "PyNINA";
    inherit version;
<<<<<<< HEAD
    hash = "sha256-uiNUkNL/3FGGhqctE9AZNdSD4o7jTk829GAT5Gy2Xeo=";
=======
    hash = "sha256-5+Mg3dPjMxEL2pgEeuR1TwiicIMHN6RO6G0SgbZm/eM=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    aiohttp
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [
    "pynina"
  ];

  meta = with lib; {
    description = "Python API wrapper to retrieve warnings from the german NINA app";
    homepage = "https://gitlab.com/DeerMaximum/pynina";
<<<<<<< HEAD
    changelog = "https://gitlab.com/DeerMaximum/pynina/-/releases/${version}";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
