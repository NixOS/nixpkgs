{ lib
, buildPythonPackage
, fetchPypi
, isodate
, html5lib
, sparqlwrapper
, networkx
, nose
, python
}:

buildPythonPackage rec {
  pname = "neurdflib";
  version = "5.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d34493cee15029ff5db16157429585ff863ba5542675a4d8a94a0da1bc6e3a50";
  };

  propagatedBuildInputs = [ isodate html5lib sparqlwrapper ];

  checkInputs = [ networkx nose ];

  # Python 2 syntax
  # Failing doctest
  doCheck = false;

  checkPhase = ''
    ${python.interpreter} run_tests.py
  '';

  meta = with lib; {
    description = "A temporary convenience package for changes waiting to be merged into the primary rdflib repo";
    homepage = "https://pypi.org/project/neurdflib";
    license = licenses.bsd3;
  };
}
