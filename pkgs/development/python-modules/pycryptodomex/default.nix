{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "pycryptodomex";
  name = "${pname}-${version}";
  version = "3.4.7";

  meta = {
    description = "A self-contained cryptographic library for Python";
    homepage = https://www.pycryptodome.org;
    license = lib.licenses.bsd2;
  };

  src = fetchPypi {
    inherit pname version;
    sha256 = "52aa2e540d06d63636e4b5356957c520611e28a88386bad4d18980e4b00e0b5a";
  };
}
