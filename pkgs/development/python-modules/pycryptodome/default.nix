{ stdenv, fetchPypi, buildPythonPackage }:

buildPythonPackage rec {
  version = "3.6.5";
  pname = "pycryptodome";

  src = fetchPypi {
    inherit pname version;
    sha256 = "99d653f3a92f35e3c768a142aa83c8c7b104a787655c51e25dca89ed778960b8";
  };

  meta = {
    homepage = https://www.pycryptodome.org/;
    description = "Python Cryptography Toolkit";
    platforms = stdenv.lib.platforms.unix;
  };
}
