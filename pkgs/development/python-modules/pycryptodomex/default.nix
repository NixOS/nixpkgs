{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "pycryptodomex";
  name = "${pname}-${version}";
  version = "3.6.2";

  meta = {
    description = "A self-contained cryptographic library for Python";
    homepage = https://www.pycryptodome.org;
    license = lib.licenses.bsd2;
  };

  src = fetchPypi {
    inherit pname version;
    sha256 = "8ed51799f6c060b4f62459e1bd9f3b3855bec6fa68202e76639d628001fdf3b7";
  };
}
