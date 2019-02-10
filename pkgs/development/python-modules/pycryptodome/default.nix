{ stdenv, fetchPypi, buildPythonPackage }:

buildPythonPackage rec {
  version = "3.7.2";
  pname = "pycryptodome";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f5fc7e3b2d29552f0383063408ce2bd295e9d3c7ef13377599aa300a3d2baef7";
  };

  meta = {
    homepage = https://www.pycryptodome.org/;
    description = "Python Cryptography Toolkit";
    platforms = stdenv.lib.platforms.unix;
  };
}
