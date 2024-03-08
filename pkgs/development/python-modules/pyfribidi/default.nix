{ lib
, stdenv
, buildPythonPackage
, fetchPypi
, isPyPy
, six
}:

buildPythonPackage rec {
  version = "0.12.0";
  format = "setuptools";
  pname = "pyfribidi";
  disabled = isPyPy;

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "64726a4a56783acdc79c6b9b3a15f16e6071077c897a0b999f3b43f744bc621c";
  };

  patches = lib.optional stdenv.cc.isClang ./pyfribidi-clang.patch;

  propagatedBuildInputs = [ six ];

  meta = with lib; {
    description = "A simple wrapper around fribidi";
    homepage = "https://github.com/pediapress/pyfribidi";
    license = licenses.gpl2;
  };

}
