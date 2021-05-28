{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "pycryptodomex";
  version = "3.9.8";

  meta = {
    description = "A self-contained cryptographic library for Python";
    homepage = "https://www.pycryptodome.org";
    license = lib.licenses.bsd2;
  };

  src = fetchPypi {
    inherit pname version;
    sha256 = "48cc2cfc251f04a6142badeb666d1ff49ca6fdfc303fd72579f62b768aaa52b9";
  };
}
