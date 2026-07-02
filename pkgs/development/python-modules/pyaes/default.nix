{
  lib,
  fetchPypi,
  buildPythonPackage,
}:

buildPythonPackage rec {
  pname = "pyaes";
  version = "1.6.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "02c1b1405c38d3c370b085fb952dd8bea3fadcee6411ad99f312cc129c536d8f";
  };

  patches = [
    # https://github.com/ricmoo/pyaes/issues/56
    # https://blog.trailofbits.com/2026/02/18/carelessness-versus-craftsmanship-in-cryptography/
    ./default-iv.patch
  ];

  meta = {
    description = "Pure-Python AES";
    license = lib.licenses.mit;
    homepage = "https://github.com/ricmoo/pyaes";
  };
}
