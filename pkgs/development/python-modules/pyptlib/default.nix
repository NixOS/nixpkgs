{ lib
, buildPythonPackage
, fetchPypi
, isPyPy
, isPy3k
}:

buildPythonPackage rec {
  pname = "pyptlib";
  version = "0.0.6";
  format = "setuptools";
  disabled = isPyPy || isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "01y6vbwncqb0hxlnin6whd9wrrm5my4qzjhk76fnix78v7ip515r";
  };

  doCheck = false;  # No such file or directory errors on 32bit

  meta = with lib; {
    homepage = "https://pypi.org/project/pyptlib/";
    description = "A python implementation of the Pluggable Transports for Circumvention specification for Tor";
    license = licenses.bsd2;
  };

}
