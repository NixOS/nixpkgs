{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
, requests
}:

buildPythonPackage rec {
  pname = "pyfritzhome";
<<<<<<< HEAD
  version = "0.6.9";
=======
  version = "0.6.8";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "hthiery";
    repo = "python-fritzhome";
    rev = "refs/tags/${version}";
<<<<<<< HEAD
    hash = "sha256-BhJkUbTAzMkzWINVoBDG2Vnf4Fd+kX1oBkXWD7UNbTw=";
=======
    hash = "sha256-MIWRBwqVuS1iEuWxsE1yuGS2zHYVgnH2G4JJk7Yct6s=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    requests
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "pyfritzhome"
  ];

  meta = with lib; {
    description = "Python Library to access AVM FRITZ!Box homeautomation";
    homepage = "https://github.com/hthiery/python-fritzhome";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
  };
}
