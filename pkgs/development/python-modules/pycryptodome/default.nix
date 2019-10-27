{ stdenv, fetchPypi, buildPythonPackage }:

buildPythonPackage rec {
  version = "3.9.0";
  pname = "pycryptodome";

  src = fetchPypi {
    inherit pname version;
    sha256 = "dbeb08ad850056747aa7d5f33273b7ce0b9a77910604a1be7b7a6f2ef076213f";
  };

  meta = {
    homepage = https://www.pycryptodome.org/;
    description = "Python Cryptography Toolkit";
    platforms = stdenv.lib.platforms.unix;
  };
}
