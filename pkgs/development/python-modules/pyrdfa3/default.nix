{
  lib,
  buildPythonPackage,
  fetchPypi,
  html5lib,
  pythonOlder,
  rdflib,
  requests,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pyrdfa3";
  version = "3.6.4";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
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

  meta = with lib; {
    description = "RDFa 1.1 distiller/parser library";
    homepage = "https://github.com/prrvchr/pyrdfa3/";
    changelog = "https://github.com/prrvchr/pyrdfa3/releases/tag/v${version}";
    license = licenses.w3c;
    maintainers = with maintainers; [ ambroisie ];
  };
}
