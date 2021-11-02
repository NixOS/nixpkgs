{ lib, fetchPypi, buildPythonPackage }:

buildPythonPackage rec {
  version = "3.11.0";
  pname = "pycryptodome";

  src = fetchPypi {
    inherit pname version;
    sha256 = "428096bbf7a77e207f418dfd4d7c284df8ade81d2dc80f010e92753a3e406ad0";
  };

  meta = with lib; {
    homepage = "https://www.pycryptodome.org/";
    description = "Python Cryptography Toolkit";
    platforms = platforms.unix;
  };
}
