<<<<<<< HEAD
{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
}:
=======
{ lib, buildPythonPackage, fetchPypi, d2to1 }:
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

buildPythonPackage rec {
  pname = "colour";
  version = "0.1.5";
<<<<<<< HEAD
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ryASD+/Sr+3osAH77y6p2nCtfUn6/bZIkCXa6HRcOu4=";
  };

  patches = [
    # https://github.com/vaab/colour/pull/66 (but does not merge cleanly)
    ./remove-unmaintained-d2to1.diff
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pytestFlagsArray = [
    "--doctest-glob=\"*.rst\""
    "--doctest-modules"
  ];

  pythonImportsCheck = [
    "colour"
  ];
=======

  src = fetchPypi {
    inherit pname version;
    sha256 = "af20120fefd2afede8b001fbef2ea9da70ad7d49fafdb6489025dae8745c3aee";
  };

  buildInputs = [ d2to1 ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "Converts and manipulates common color representation (RGB, HSV, web, ...)";
    homepage = "https://github.com/vaab/colour";
    license = licenses.bsd2;
  };
}
