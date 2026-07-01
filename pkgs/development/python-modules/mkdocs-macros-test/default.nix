{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "mkdocs-macros-test";
  version = "0.1.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-xaujzQYPKKmATRT/Dto4KHyDNzUpqR2+6SIDiurUIvA=";
  };

  build-system = [
    setuptools
  ];

  pythonImportsCheck = [
    "mkdocs_macros_test"
  ];

  meta = {
    description = "Implementation of a (model) pluglet for mkdocs-macros";
    homepage = "https://github.com/fralau/mkdocs-macros-test";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ marcel ];
  };
}
