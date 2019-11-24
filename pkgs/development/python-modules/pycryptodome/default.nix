{ stdenv, fetchPypi, buildPythonPackage }:

buildPythonPackage rec {
  version = "3.9.2";
  pname = "pycryptodome";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e1e007d072d50844188c067c325af8b3ad31e4b87792381469b821e95bf14cd8";
  };

  meta = {
    homepage = https://www.pycryptodome.org/;
    description = "Python Cryptography Toolkit";
    platforms = stdenv.lib.platforms.unix;
  };
}
