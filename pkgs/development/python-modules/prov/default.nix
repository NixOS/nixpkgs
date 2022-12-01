{ lib
, buildPythonPackage
, fetchPypi
, lxml
, networkx
, python-dateutil
, rdflib
, pydot
}:

buildPythonPackage rec {
  pname = "prov";
  version = "2.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b6438f2195ecb9f6e8279b58971e02bc51814599b5d5383366eef91d867422ee";
  };

  propagatedBuildInputs = [
    lxml
    networkx
    python-dateutil
    rdflib
  ];

  checkInputs = [
    pydot
  ];

  # Multiple tests are out-dated and failing
  doCheck = false;

  pythonImportsCheck = [
    "prov"
  ];

  meta = with lib; {
    description = "Python library for W3C Provenance Data Model (PROV)";
    homepage = "https://github.com/trungdong/prov";
    license = licenses.mit;
    maintainers = with maintainers; [ ashgillman ];
  };
}
