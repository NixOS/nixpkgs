{
  lib,
  buildPythonPackage,
  fetchPypi,
  html5lib,
  rdflib,
  requests,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "pyrdfa3";
  version = "3.6.4";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-ZHEtGkvyGCllKzlxW62m58A7zxnLSfliwZCjj0YXIkM=";
  };

  build-system = [ setuptools ];

  dependencies = [
    rdflib
    html5lib
    requests
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "pyRdfa" ];

  meta = {
    description = "RDFa 1.1 distiller/parser library";
    homepage = "https://github.com/prrvchr/pyrdfa3/";
    changelog = "https://github.com/prrvchr/pyrdfa3/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.w3c;
    maintainers = with lib.maintainers; [ ambroisie ];
  };
})
