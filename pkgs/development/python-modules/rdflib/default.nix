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
  version = "4.2.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0398c714znnhaa2x7v51b269hk20iz073knq2mvmqp2ma92z27fs";
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
    homepage = http://www.rdflib.net/;
  };
}