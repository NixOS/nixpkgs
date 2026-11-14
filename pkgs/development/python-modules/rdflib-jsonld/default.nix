{
  lib,
  fetchPypi,
  buildPythonPackage,
  rdflib,
  setuptools,
}:

buildPythonPackage rec {
  pname = "rdflib-jsonld";
  version = "0.6.1";
  format = "setuptools";
  strictDeps = true;
  __structuredAttrs = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-7aWkKi4J+A1Np44ytcaEvM3ydTaPFUHmt7zd+xOCoOA=";
  };

  build-system = [ setuptools ];
  propagatedBuildInputs = [ rdflib ];

  pythonImportsCheck = [ "rdflib_jsonld" ];

  meta = {
    description = "JSON-LD parser and serializer for RDFLib";
    homepage = "https://github.com/RDFLib/rdflib-jsonld";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ philocalyst ];
  };
}
