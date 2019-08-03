{ lib
, buildPythonPackage
, fetchPypi
, isodate
, html5lib
, SPARQLWrapper
, networkx
, nose
, python
}:

buildPythonPackage rec {
  pname = "neurdflib";
  version = "5.0.0.post1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1qgmprixqxycxpjk9wjdmjykma14qqa2wcbx4nsldxi0ga7i7vv5";
  };

  propagatedBuildInputs = [ isodate html5lib SPARQLWrapper ];

  checkInputs = [ networkx nose ];

  # Python 2 syntax
  # Failing doctest
  doCheck = false;

  checkPhase = ''
    ${python.interpreter} run_tests.py
  '';

  meta = with lib; {
    description = "A temporary convenience package for changes waiting to be merged into the primary rdflib repo";
    homepage = https://pypi.org/project/neurdflib;
    license = licenses.bsd3;
  };
}
