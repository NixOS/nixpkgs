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
  version = "6.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "7ce4d757eb26f4dd43205ec340d8c097f29e5adfe45d6ea20238c731dc679879";
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
