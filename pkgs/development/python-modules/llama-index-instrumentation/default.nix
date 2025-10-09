{
  lib,
  buildPythonPackage,
  deprecated,
  fetchPypi,
  hatchling,
  pydantic,
}:

buildPythonPackage rec {
  pname = "llama-index-instrumentation";
  version = "0.4.1";
  pyproject = true;

  src = fetchPypi {
    pname = "llama_index_instrumentation";
    inherit version;
    hash = "sha256-p50N0rq6NPBf9DVNY6mbISMiY1uK+mzJbtAKfhHr/cM=";
  };

  pythonRelaxDeps = [ "pydantic" ];

  build-system = [ hatchling ];

  dependencies = [
    deprecated
    pydantic
  ];

  pythonImportsCheck = [ "llama_index_instrumentation" ];

  meta = {
    description = "Support for instrumentation in LlamaIndex applications";
    homepage = "https://pypi.org/project/llama-index-instrumentation/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
