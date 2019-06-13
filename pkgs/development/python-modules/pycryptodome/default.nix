{ stdenv, fetchPypi, buildPythonPackage }:

buildPythonPackage rec {
  version = "3.7.3";
  pname = "pycryptodome";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1a222250e43f3c659b4ebd5df3e11c2f112aab6aef58e38af55ef5678b9f0636";
  };

  meta = {
    homepage = https://www.pycryptodome.org/;
    description = "Python Cryptography Toolkit";
    platforms = stdenv.lib.platforms.unix;
  };
}
