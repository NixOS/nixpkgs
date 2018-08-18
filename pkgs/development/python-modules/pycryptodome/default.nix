{ stdenv, fetchPypi, buildPythonPackage }:

buildPythonPackage rec {
  version = "3.6.4";
  pname = "pycryptodome";

  src = fetchPypi {
    inherit pname version;
    sha256 = "9c7790ffd291c81b934fe0ca8155a67235d33f70d4914bbf7467a447d9dbcb09";
  };

  meta = {
    homepage = https://www.pycryptodome.org/;
    description = "Python Cryptography Toolkit";
    platforms = stdenv.lib.platforms.unix;
  };
}
