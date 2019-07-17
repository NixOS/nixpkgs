{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "pycryptodomex";
  version = "3.8.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "01qnl81s8qdmkmwindvcz8zk05bbhk5iin3hppwbbimxdfpia2z5";
  };

  meta = {
    description = "A self-contained cryptographic library for Python";
    homepage = https://www.pycryptodome.org;
    license = lib.licenses.bsd2;
  };
}
