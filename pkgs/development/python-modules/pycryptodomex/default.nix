{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "pycryptodomex";
  name = "${pname}-${version}";
  version = "3.4.9";

  meta = {
    description = "A self-contained cryptographic library for Python";
    homepage = https://www.pycryptodome.org;
    license = lib.licenses.bsd2;
  };

  src = fetchPypi {
    inherit pname version;
    sha256 = "d078b67be76ccafa8b7cc391e87151b80b0ef9bfbeee8a95d286e522cc7537f7";
  };
}
