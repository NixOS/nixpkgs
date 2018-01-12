{ stdenv, buildPythonPackage, fetchurl, isPy3k, nose
, html5lib, isodate, networkx, pyparsing, SPARQLWrapper }:

buildPythonPackage rec {
  name = "rdflib-4.2.2";

  src = fetchurl {
    url = "mirror://pypi/r/rdflib/${name}.tar.gz";
    sha256 = "0398c714znnhaa2x7v51b269hk20iz073knq2mvmqp2ma92z27fs";
  };

  #    File "/tmp/nix-build-python3.6-rdflib-4.2.2.drv-0/rdflib-4.2.2/rdflib/__init__.py", line 99, in <module>
  #      unichr(0x10FFFF)
  #  NameError: name 'unichr' is not defined
  doCheck = !isPy3k;

  buildInputs = [ nose ];
  propagatedBuildInputs = [ isodate html5lib networkx pyparsing SPARQLWrapper ];

  meta = {
    description = "A Python library for working with RDF, a simple yet powerful language for representing information";
    homepage = http://www.rdflib.net/;
  };
}

