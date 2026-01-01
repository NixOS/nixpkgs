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
  version = "2.1.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-fQErFk9bu0LhGO2dJXiKsBLQkIK3Iryd1OgRownqV/U=";
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

<<<<<<< HEAD
  meta = {
    description = "Python library for W3C Provenance Data Model (PROV)";
    homepage = "https://github.com/trungdong/prov";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ashgillman ];
=======
  meta = with lib; {
    description = "Python library for W3C Provenance Data Model (PROV)";
    homepage = "https://github.com/trungdong/prov";
    license = licenses.mit;
    maintainers = with maintainers; [ ashgillman ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
