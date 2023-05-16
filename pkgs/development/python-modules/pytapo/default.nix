{ lib
, buildPythonPackage
, fetchPypi
<<<<<<< HEAD
, pythonOlder
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

# propagates
, pycryptodome
, requests
, rtp
, urllib3
}:

buildPythonPackage rec {
  pname = "pytapo";
<<<<<<< HEAD
  version = "3.2.14";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-V/D+eE6y1kCMZmp9rIcvS/wdcSyW3mYWEJqpCb74NtY=";
=======
  version = "3.1.7";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-e5XeXPwf2QSZ/xgaPBPoRBaTvC8oNYI9/b190wSI4oQ=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    pycryptodome
    requests
    rtp
    urllib3
  ];

  pythonImportsCheck = [
    "pytapo"
  ];

  # Tests require actual hardware
  doCheck = false;

  meta = with lib; {
<<<<<<< HEAD
    description = "Python library for communication with Tapo Cameras";
=======
    description = "Python library for communication with Tapo Cameras ";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    homepage = "https://github.com/JurajNyiri/pytapo";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fleaz ];
  };
}
