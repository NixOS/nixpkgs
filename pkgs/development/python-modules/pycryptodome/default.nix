{ stdenv, fetchPypi, buildPythonPackage }:

buildPythonPackage rec {
  version = "3.9.7";
  pname = "pycryptodome";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f1add21b6d179179b3c177c33d18a2186a09cc0d3af41ff5ed3f377360b869f2";
  };

  meta = {
    homepage = "https://www.pycryptodome.org/";
    description = "Python Cryptography Toolkit";
    platforms = stdenv.lib.platforms.unix;
  };
}
