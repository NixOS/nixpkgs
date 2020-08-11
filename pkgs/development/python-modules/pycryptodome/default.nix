{ stdenv, fetchPypi, buildPythonPackage }:

buildPythonPackage rec {
  version = "3.9.8";
  pname = "pycryptodome";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0e24171cf01021bc5dc17d6a9d4f33a048f09d62cc3f62541e95ef104588bda4";
  };

  meta = {
    homepage = "https://www.pycryptodome.org/";
    description = "Python Cryptography Toolkit";
    platforms = stdenv.lib.platforms.unix;
  };
}
