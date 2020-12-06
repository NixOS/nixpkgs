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
  version = "2.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b6438f2195ecb9f6e8279b58971e02bc51814599b5d5383366eef91d867422ee";
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
    homepage = "https://github.com/trungdong/prov";
    license = licenses.mit;
    maintainers = with maintainers; [ ashgillman ];
  };
}
