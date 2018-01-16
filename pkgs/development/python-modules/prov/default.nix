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
  name = "${pname}-${version}";
  pname = "prov";
  version = "1.5.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1vkpayns0mf7i2357vxyvi2n5h5xsyg56ik2yqgrc91k3gx4x9wn";
  };

  propagatedBuildInputs = [
    lxml
    networkx
    dateutil
    six
    pydotplus
    rdflib
  ];
  doCheck = false; # takes forever!

  meta = with stdenv.lib; {
    description = "A Python library for W3C Provenance Data Model (PROV)";
    homepage = https://github.com/trungdong/prov;
    license = licenses.mit;
    maintainers = with maintainers; [ ashgillman ];
  };
}
