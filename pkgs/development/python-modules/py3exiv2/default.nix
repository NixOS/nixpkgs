{ lib
, stdenv
, boost
, buildPythonPackage
, exiv2
, fetchPypi
, libcxx
, pythonOlder
}:

buildPythonPackage rec {
  pname = "py3exiv2";
<<<<<<< HEAD
  version = "0.12.0";
=======
  version = "0.11.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-crI+X3YMRzPPmpGNsI2U+9bZgwcR0qTowJuPNFY/Ooo=";
=======
    hash = "sha256-ZgDaa4lxmdTaZhkblgRfPMxfVwENp2s6xdKSuD/MqEQ=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  buildInputs = [
    boost
    exiv2
  ];

  # Work around Python distutils compiling C++ with $CC (see issue #26709)
  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.isDarwin "-I${lib.getDev libcxx}/include/c++/v1";

  pythonImportsCheck = [
    "pyexiv2"
  ];

  # Tests are not shipped
  doCheck = false;

  meta = with lib; {
    broken = stdenv.isDarwin;
    description = "Python binding to the library exiv2";
    homepage = "https://launchpad.net/py3exiv2";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ vinymeuh ];
    platforms = with platforms; linux ++ darwin;
  };
}
