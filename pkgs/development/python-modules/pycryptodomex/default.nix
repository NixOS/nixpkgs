{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "pycryptodomex";
  name = "${pname}-${version}";
  version = "3.5.1";

  meta = {
    description = "A self-contained cryptographic library for Python";
    homepage = https://www.pycryptodome.org;
    license = lib.licenses.bsd2;
  };

  src = fetchPypi {
    inherit pname version;
    sha256 = "bb60d38111ebc383a5a1c909545562926c66c846d03fc65ba7b8a3487cb23078";
  };
}
