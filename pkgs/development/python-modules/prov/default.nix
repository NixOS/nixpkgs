{ stdenv
, buildPythonPackage
, fetchPypi
, lxml
, networkx
, dateutil
, six
, pydotplus
, rdflib
}:

buildPythonPackage rec {
  pname = "prov";
  version = "1.5.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "7a2d72b0df43cd9c6e374d815c8ce3cd5ca371d54f98f837853ac9fcc98aee4c";
  };

  propagatedBuildInputs = [
    lxml
    networkx
    dateutil
    six
    pydotplus
    rdflib
  ];
  doCheck = false; # takes ~60 mins

  meta = with stdenv.lib; {
    description = "A Python library for W3C Provenance Data Model (PROV)";
    homepage = https://github.com/trungdong/prov;
    license = licenses.mit;
    maintainers = with maintainers; [ ashgillman ];
  };
}
