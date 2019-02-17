{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "pycryptodomex";
  version = "3.7.2";

  meta = {
    description = "A self-contained cryptographic library for Python";
    homepage = https://www.pycryptodome.org;
    license = lib.licenses.bsd2;
  };

  src = fetchPypi {
    inherit pname version;
    sha256 = "5d4e10ad9ff7940da534119ef92a500dcf7c28351d15e12d74ef0ce025e37d5b";
  };
}
