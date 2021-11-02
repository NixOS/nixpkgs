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
  version = "6.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f071caff0b68634e4a7bd1d66ea3416ac98f1cc3b915938147ea899c32608728";
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
