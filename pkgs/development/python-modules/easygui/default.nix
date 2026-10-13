{
  lib,
  fetchPypi,
  buildPythonPackage,
  setuptools,
  tkinter,
}:

buildPythonPackage (finalAttrs: {
  pname = "easygui";
  version = "0.98.3";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-1lP/ee4fQvY7WgkPL5jOAjNdhq2JY7POJmGAXK/pmgQ=";
  };

  build-system = [ setuptools ];

  dependencies = [ tkinter ];

  doCheck = false; # No tests available

  pythonImportsCheck = [ "easygui" ];

  meta = {
    description = "Very simple, very easy GUI programming in Python";
    homepage = "https://github.com/robertlugg/easygui";
    license = lib.licenses.bsd3;
    maintainers = [ ];
  };
})
