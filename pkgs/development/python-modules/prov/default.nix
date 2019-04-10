{ stdenv
, buildPythonPackage
, fetchPypi
, lxml
, networkx
, dateutil
, six
, pydotplus
, rdflib
, pydot
, glibcLocales
}:

buildPythonPackage rec {
  pname = "prov";
  version = "1.5.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1a9h406laclxalmdny37m0yyw7y17n359akclbahimdggq853jd0";
  };

  prePatch = ''
    substituteInPlace setup.py --replace "six==1.10.0" "six>=1.10.0"
  '';

  propagatedBuildInputs = [
    lxml
    networkx
    dateutil
    six
    pydotplus
    rdflib
  ];

  checkInputs = [
    pydot
    glibcLocales
  ];

  preCheck = ''
    export LC_ALL="en_US.utf-8"
  '';

  meta = with stdenv.lib; {
    description = "A Python library for W3C Provenance Data Model (PROV)";
    homepage = https://github.com/trungdong/prov;
    license = licenses.mit;
    maintainers = with maintainers; [ ashgillman ];
  };
}
