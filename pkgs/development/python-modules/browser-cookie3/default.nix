<<<<<<< HEAD
{ lib
=======
{ stdenv
, lib
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, fetchPypi
, buildPythonPackage
, pythonOlder
, lz4
, keyring
, pbkdf2
, pycryptodomex
, pyaes
}:

buildPythonPackage rec {
  pname = "browser-cookie3";
<<<<<<< HEAD
  version = "0.19.1";
=======
  version = "0.18.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-MDGtFLlrR+8eTIVF8vRj4QrYRO+DTc0Ova42HjHGEZo=";
=======
    hash = "sha256-bSP6likSwEbxN4S9qbJmPcs8joc5e10FiqVL9gE7ni8=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    lz4
    keyring
    pbkdf2
    pyaes
    pycryptodomex
  ];

  # No tests implemented
  doCheck = false;

  pythonImportsCheck = [
    "browser_cookie3"
  ];

  meta = with lib; {
    description = "Loads cookies from your browser into a cookiejar object";
    homepage = "https://github.com/borisbabic/browser_cookie3";
    changelog = "https://github.com/borisbabic/browser_cookie3/blob/master/CHANGELOG.md";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ borisbabic ];
<<<<<<< HEAD
=======
    broken = stdenv.isDarwin;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
