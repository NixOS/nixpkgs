{ lib, fetchPypi, buildPythonPackage }:

buildPythonPackage rec {
  version = "3.9.9";
  pname = "pycryptodome";

  src = fetchPypi {
    inherit pname version;
    sha256 = "910e202a557e1131b1c1b3f17a63914d57aac55cf9fb9b51644962841c3995c4";
  };

  meta = with lib; {
    homepage = "https://www.pycryptodome.org/";
    description = "Python Cryptography Toolkit";
    platforms = platforms.unix;
  };
}
