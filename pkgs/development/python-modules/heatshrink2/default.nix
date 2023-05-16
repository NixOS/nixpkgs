<<<<<<< HEAD
{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
=======
{ buildPythonPackage
, fetchFromGitHub
, lib
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonPackage rec {
  pname = "heatshrink2";
<<<<<<< HEAD
  version = "0.12.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";
=======
  version = "0.11.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "eerimoq";
    repo = "pyheatshrink";
<<<<<<< HEAD
    rev = "refs/tags/${version}";
    fetchSubmodules = true;
    hash = "sha256-JthHYq78SYr49+sTNtLZ8GjtrHcr1dzXcPskTrb4M3o=";
  };

  pythonImportsCheck = [
    "heatshrink2"
  ];

  meta = with lib; {
    description = "Compression using the Heatshrink algorithm";
=======
    rev = version;
    fetchSubmodules = true;
    hash = "sha256-P3IofGbW4x+erGCyxIPvD9aNHIJ/GjjWgno4n95SQoQ=";
  };

  pythonImportsCheck = [ "heatshrink2" ];

  meta = with lib; {
    description = "Compression using the Heatshrink algorithm in Python 3.";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    homepage = "https://github.com/eerimoq/pyheatshrink";
    license = licenses.isc;
    maintainers = with maintainers; [ prusnak ];
  };
}
