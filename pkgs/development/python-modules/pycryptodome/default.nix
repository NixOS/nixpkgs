{ stdenv, fetchPypi, buildPythonPackage }:

buildPythonPackage rec {
  version = "3.6.6";
  pname = "pycryptodome";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b3cb4af317d9b84f6df50f0cfa6840ba69556af637a83fd971537823e13d601a";
  };

  meta = {
    homepage = https://www.pycryptodome.org/;
    description = "Python Cryptography Toolkit";
    platforms = stdenv.lib.platforms.unix;
  };
}
