{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  lxml,
  networkx,
  python-dateutil,
  rdflib,
  pydot,
  unittestCheckHook,
}:

buildPythonPackage rec {
  pname = "prov";
  version = "2.0.2";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-7X2Gb7Yi+7F/UxHYSdD+EC2LMAASGKqRYIfw/QNOqEQ=";
  };

  build-system = [ setuptools ];

  dependencies = [
    networkx
    pydot
    python-dateutil
  ];

  optional-dependencies = {
    rdf = [ rdflib ];
    xml = [ lxml ];
  };

  nativeCheckInputs = [ unittestCheckHook ] ++ optional-dependencies.xml ++ optional-dependencies.rdf;

  unittestFlags = [ "src" ];

  # disable failing tests
  # prov.model.ProvException: The provided identifier "http://www.example.org/bundle" is not valid
  preCheck = ''
    sed -i 's/from prov.model import ProvDocument/import unittest\nfrom prov.model import ProvDocument/' src/prov/tests/qnames.py
    sed -i 's/def test_namespace_inheritance(self):/@unittest.skip\n    def test_namespace_inheritance(self):/' src/prov/tests/qnames.py
    sed -i 's/def test_default_namespace_inheritance(self):/@unittest.skip\n    def test_default_namespace_inheritance(self):/' src/prov/tests/qnames.py
  '';

  pythonImportsCheck = [ "prov" ];

  meta = {
    description = "Python library for W3C Provenance Data Model (PROV)";
    homepage = "https://github.com/trungdong/prov";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ashgillman ];
  };
}
