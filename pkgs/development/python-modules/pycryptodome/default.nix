{ stdenv, fetchPypi, buildPythonPackage }:

buildPythonPackage rec {
  version = "3.7.0";
  pname = "pycryptodome";

  src = fetchPypi {
    inherit pname version;
    sha256 = "4444a26fc3830c0d438bca6975ff10d1eb9c0b88f747fdc25b5ab81fb46713d7";
  };

  meta = {
    homepage = https://www.pycryptodome.org/;
    description = "Python Cryptography Toolkit";
    platforms = stdenv.lib.platforms.unix;
  };
}
