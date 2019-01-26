{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "pycryptodomex";
  version = "3.7.0";

  meta = {
    description = "A self-contained cryptographic library for Python";
    homepage = https://www.pycryptodome.org;
    license = lib.licenses.bsd2;
  };

  src = fetchPypi {
    inherit pname version;
    sha256 = "9f11823636128acbe4e17c35ff668f4d0a9f3133450753a0675525b6413aa1b0";
  };
}
