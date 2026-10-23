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
  version = "0.36.1";
  pyproject = true;
  __structuredAttrs = true;

  # Not available in any repository
  src = fetchPypi {
    pname = "langgraph_runtime_inmem";
    inherit (finalAttrs) version;
    hash = "sha256-XwQ/PNbRrhiKV/G85eIneLGCQeERg0U2Uu48wbk3c18=";
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
