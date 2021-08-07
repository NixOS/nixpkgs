{ lib, fetchPypi, buildPythonPackage }:

buildPythonPackage rec {
  version = "3.10.1";
  pname = "pycryptodome";

  src = fetchPypi {
    inherit pname version;
    sha256 = "3e2e3a06580c5f190df843cdb90ea28d61099cf4924334d5297a995de68e4673";
  };

  meta = with lib; {
    homepage = "https://www.pycryptodome.org/";
    description = "Python Cryptography Toolkit";
    platforms = platforms.unix;
  };
}
