{
  lib,
  buildPythonPackage,
  fetchPypi,
  hatchling,
  blockbuster,
  croniter,
  langgraph,
  langgraph-checkpoint,
  sse-starlette,
  starlette,
  structlog,
}:

buildPythonPackage (finalAttrs: {
  pname = "langgraph-runtime-inmem";
  version = "0.26.0";
  pyproject = true;

  # Not available in any repository
  src = fetchPypi {
    pname = "langgraph_runtime_inmem";
    inherit (finalAttrs) version;
    hash = "sha256-ucWH0TOTIKKlSlcKIa7K9Z7rxL4HzvHYpbA18/LGHWo=";
  };

  build-system = [ hatchling ];

  dependencies = [
    blockbuster
    croniter
    langgraph
    langgraph-checkpoint
    sse-starlette
    starlette
    structlog
  ];

  pythonImportsCheck = [ "langgraph_runtime_inmem" ];

  # no tests
  doCheck = false;

  meta = {
    description = "Inmem implementation for the LangGraph API server";
    homepage = "https://pypi.org/project/langgraph-runtime-inmem/";
    # no changelog
    license = lib.licenses.elastic20;
    maintainers = with lib.maintainers; [ sarahec ];
  };
})
