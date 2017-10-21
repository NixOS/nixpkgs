{ lib, fetchPypi, buildPythonPackage }:

buildPythonPackage rec {
  pname = "pyaes";
  version = "1.6.0";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0bp9bjqy1n6ij1zb86wz9lqa1dhla8qr1d7w2kxyn7jbj56sbmcw";
  };

  meta = {
    description = "Pure-Python AES";
    license = lib.licenses.mit;
    homepage = https://github.com/ricmoo/pyaes;
  };
}
