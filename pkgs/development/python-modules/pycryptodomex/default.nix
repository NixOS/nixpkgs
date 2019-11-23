{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "pycryptodomex";
  version = "3.9.0";

  meta = {
    description = "A self-contained cryptographic library for Python";
    homepage = https://www.pycryptodome.org;
    license = lib.licenses.bsd2;
  };

  src = fetchPypi {
    inherit pname version;
    sha256 = "8b604f4fa1de456d6d19771b01c2823675a75a2c60e51a6b738f71fdfe865370";
  };
}
