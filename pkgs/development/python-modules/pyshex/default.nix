{
  lib,
  fetchPypi,
  buildPythonPackage,
  cfgraph,
  chardet_7_4,
  hatchling,
  pyshexc,
  rdflib-shim,
  requests,
  shexjsg,
  sparqlslurper,
  sparqlwrapper,
  urllib3,
  uv-dynamic-versioning,
}:

buildPythonPackage rec {
  pname = "pyshex";
  version = "0.9.0";
  pyproject = true;
  strictDeps = true;
  __structuredAttrs = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-hyiLXlYT9zT1XwCFM0VYIY/2GPsQYaq9zuGYQQkrPso=";
  };

  build-system = [
    hatchling
    uv-dynamic-versioning
  ];

  propagatedBuildInputs = [
    cfgraph
    chardet_7_4
    pyshexc
    rdflib-shim
    requests
    shexjsg
    sparqlslurper
    sparqlwrapper
    urllib3
  ];

  pythonImportsCheck = [ "pyshex" ];

  meta = {
    description = "Python implementation of the ShEx language";
    homepage = "https://github.com/hsolbrig/PyShEx";
    license = lib.licenses.cc0;
    maintainers = with lib.maintainers; [ philocalyst ];
  };
}
