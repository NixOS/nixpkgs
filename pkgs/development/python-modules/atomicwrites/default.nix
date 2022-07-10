{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "atomicwrites";
  version = "1.4.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-gbLJBxpJNnp/dwFw5e7Iy2ZWfPu8jHPSDOXKSo1xzxE=";
  };

  # Tests depend on pytest but atomicwrites is a dependency of pytest
  doCheck = false;

  pythonImportsCheck = [
    "atomicwrites"
  ];

  meta = with lib; {
    description = "Atomic file writes on POSIX";
    homepage = "https://python-atomicwrites.readthedocs.io/";
    license = licenses.mit;
    maintainers = with maintainers; [ matthiasbeyer ];
  };
}
