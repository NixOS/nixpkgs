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
  version = "2.0.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-DiOMFAXRpVxyvTmzttc9b3q/2dCn+rLsBpOhmimlYX8=";
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
