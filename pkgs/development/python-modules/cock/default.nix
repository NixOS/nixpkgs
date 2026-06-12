{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  click,
  sortedcontainers,
  pyyaml,
}:

buildPythonPackage (finalAttrs: {
  pname = "cock";
  version = "0.11.0";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-Hi8aFxATsYcEO6qNzZnF73V8WLTQjb6Dw2xF4VgT2o4=";
  };

  build-system = [ setuptools ];

  dependencies = [
    click
    sortedcontainers
    pyyaml
  ];

  pythonImportsCheck = [ "cock" ];

  meta = {
    homepage = "https://github.com/pohmelie/cock";
    description = "Configuration file with click";
    license = lib.licenses.mit;
    hasNoMaintainersButDependents = true;
  };
})
