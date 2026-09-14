{
  lib,
  fetchPypi,
  buildPythonPackage,
  setuptools,
  colorama,
}:

buildPythonPackage (finalAttrs: {
  pname = "crayons";
  version = "0.4.0";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-vTO3VHgA8s+9JrOEMfnmS0h6fedKlHsPr8ibRaYBgT8=";
  };

  build-system = [ setuptools ];

  dependencies = [ colorama ];

  pythonImportsCheck = [ "crayons" ];

  meta = {
    description = "TextUI colors for Python";
    homepage = "https://github.com/kennethreitz/crayons";
    license = lib.licenses.mit;
  };
})
