{ stdenv, fetchPypi, buildPythonPackage }:

buildPythonPackage rec {
  version = "3.9.4";
  pname = "pycryptodome";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a168e73879619b467072509a223282a02c8047d932a48b74fbd498f27224aa04";
  };

  meta = {
    homepage = https://www.pycryptodome.org/;
    description = "Python Cryptography Toolkit";
    platforms = stdenv.lib.platforms.unix;
  };
}
