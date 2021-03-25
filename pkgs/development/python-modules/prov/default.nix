{ lib
, buildPythonPackage
, fetchPypi
, lxml
, networkx
, dateutil
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
    dateutil
    rdflib
  ];

  checkInputs = [
    pydot
  ];

  meta = with lib; {
    description = "A Python library for W3C Provenance Data Model (PROV)";
    homepage = "https://github.com/trungdong/prov";
    license = licenses.mit;
    maintainers = with maintainers; [ ashgillman ];
  };
}
