{
  lib,
  buildPythonPackage,
  fetchPypi,
  lxml,
  networkx,
  python-dateutil,
  rdflib,
  pydot,
}:

buildPythonPackage rec {
  pname = "prov";
  version = "2.0.2";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-7X2Gb7Yi+7F/UxHYSdD+EC2LMAASGKqRYIfw/QNOqEQ=";
  };

  propagatedBuildInputs = [
    lxml
    networkx
    python-dateutil
    rdflib
  ];

  nativeCheckInputs = [ pydot ];

  # Multiple tests are out-dated and failing
  doCheck = false;

  pythonImportsCheck = [ "prov" ];

  meta = with lib; {
    description = "Python library for W3C Provenance Data Model (PROV)";
    homepage = "https://github.com/trungdong/prov";
    license = licenses.mit;
    maintainers = with maintainers; [ ashgillman ];
  };
}
