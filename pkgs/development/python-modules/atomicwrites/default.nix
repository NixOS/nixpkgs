{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytest,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "atomicwrites";
  version = "1.4.1";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-gbLJBxpJNnp/dwFw5e7Iy2ZWfPu8jHPSDOXKSo1xzxE=";
  };

  build-system = [ setuptools ];

  # Tests depend on pytest but atomicwrites is a dependency of pytest
  doCheck = false;
  nativeCheckInputs = [ pytest ];

  meta = {
    description = "Atomic file writes on POSIX";
    homepage = "https://pypi.org/project/atomicwrites/";
    maintainers = with lib.maintainers; [ matthiasbeyer ];
    license = lib.licenses.mit;
  };
})
