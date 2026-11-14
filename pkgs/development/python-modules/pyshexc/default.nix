{
  lib,
  fetchPypi,
  buildPythonPackage,
  antlr4-python3-runtime_4_9,
  chardet_7_4,
  hatchling,
  jsonasobj,
  pyjsg,
  rdflib-shim,
  shexjsg,
  uv-dynamic-versioning,
}:

buildPythonPackage rec {
  pname = "pyshexc";
  version = "0.10.3.post1";
  pyproject = true;
  strictDeps = true;
  __structuredAttrs = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-gNnQZ8gK+aeW48HEfSIH7fLpqfw508oM5d0gGTNOqRU=";
  };

  build-system = [
    hatchling
    uv-dynamic-versioning
  ];

  propagatedBuildInputs = [
    antlr4-python3-runtime_4_9
    chardet_7_4
    jsonasobj
    pyjsg
    rdflib-shim
    shexjsg
  ];

  pythonImportsCheck = [ "pyshexc" ];

  meta = {
    description = "Python implementation of the ShExC compiler";
    homepage = "https://github.com/linkml/grammar-python-antlr-linkml";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ philocalyst ];
  };
}
