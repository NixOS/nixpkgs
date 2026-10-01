{
  lib,
  buildPythonPackage,
  deprecated,
  fetchPypi,
  hatchling,
  pydantic,
}:

buildPythonPackage (finalAttrs: {
  pname = "llama-index-instrumentation";
  version = "0.6.0";
  pyproject = true;

  src = fetchPypi {
    pname = "llama_index_instrumentation";
    inherit (finalAttrs) version;
    hash = "sha256-sYXE4op/MomcJ2ScwuLX1UJn+i/wzUPL4rUhK66Y/jo=";
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
})
