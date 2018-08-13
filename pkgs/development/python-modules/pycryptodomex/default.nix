{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "pycryptodomex";
  version = "3.6.5";

  meta = {
    description = "A self-contained cryptographic library for Python";
    homepage = https://www.pycryptodome.org;
    license = lib.licenses.bsd2;
  };

  src = fetchPypi {
    inherit pname version;
    sha256 = "ff7d28474ef2134fe3027b53fa3cf13ed5f776ce15d6209b0e48fbc7592f9396";
  };
}
