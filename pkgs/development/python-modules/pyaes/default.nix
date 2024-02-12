{ lib, fetchPypi, buildPythonPackage }:

buildPythonPackage rec {
  pname = "pyaes";
  version = "1.6.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "02c1b1405c38d3c370b085fb952dd8bea3fadcee6411ad99f312cc129c536d8f";
  };

  meta = {
    description = "Pure-Python AES";
    license = lib.licenses.mit;
    homepage = "https://github.com/ricmoo/pyaes";
  };
}
