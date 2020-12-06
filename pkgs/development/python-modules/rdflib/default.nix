{ buildPythonPackage
, fetchPypi
, isodate
, html5lib
, SPARQLWrapper
, networkx
, nose
, python
}:

buildPythonPackage rec {
  pname = "rdflib";
  version = "5.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0mdi7xh4zcr3ngqwlgqdqf0i5bxghwfddyxdng1zwpiqkpa9s53q";
  };

  propagatedBuildInputs = [isodate html5lib SPARQLWrapper ];

  checkInputs = [ networkx nose ];

  # Python 2 syntax
  # Failing doctest
  doCheck = false;

  checkPhase = ''
    ${python.interpreter} run_tests.py
  '';

  meta = {
    description = "A Python library for working with RDF, a simple yet powerful language for representing information";
    homepage = "http://www.rdflib.net/";
  };
}
