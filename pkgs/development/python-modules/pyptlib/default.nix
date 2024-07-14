{
  lib,
  buildPythonPackage,
  fetchPypi,
  isPyPy,
  isPy3k,
}:

buildPythonPackage rec {
  pname = "pyptlib";
  version = "0.0.6";
  format = "setuptools";
  disabled = isPyPy || isPy3k;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-uYRy49no9GidORPKj4mvpebMU4Pc2Ghph2BhZvnaxgc=";
  };

  doCheck = false; # No such file or directory errors on 32bit

  meta = with lib; {
    homepage = "https://pypi.org/project/pyptlib/";
    description = "Python implementation of the Pluggable Transports for Circumvention specification for Tor";
    license = licenses.bsd2;
  };
}
