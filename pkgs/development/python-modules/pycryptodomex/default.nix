{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "pycryptodomex";
  name = "${pname}-${version}";
  version = "3.6.1";

  meta = {
    description = "A self-contained cryptographic library for Python";
    homepage = https://www.pycryptodome.org;
    license = lib.licenses.bsd2;
  };

  src = fetchPypi {
    inherit pname version;
    sha256 = "82b758f870c8dd859f9b58bc9cff007403b68742f9e0376e2cbd8aa2ad3baa83";
  };
}
