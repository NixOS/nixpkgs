{ lib, buildPythonPackage, fetchPypi, pytest }:

buildPythonPackage rec {
  pname = "atomicwrites";
  version = "1.4.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-gbLJBxpJNnp/dwFw5e7Iy2ZWfPu8jHPSDOXKSo1xzxE=";
  };

  # Tests depend on pytest but atomicwrites is a dependency of pytest
  doCheck = false;
  checkInputs = [ pytest ];

  meta = with lib; {
    description = "Atomic file writes on POSIX";
    homepage = "https://pypi.python.org/pypi/atomicwrites";
    maintainers = with maintainers; [ matthiasbeyer ];
  };
}
