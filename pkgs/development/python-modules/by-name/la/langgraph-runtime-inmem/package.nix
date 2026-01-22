{
  lib,
  buildPythonPackage,
  fetchPypi,
  hatchling,
  blockbuster,
  langgraph,
  langgraph-checkpoint,
  sse-starlette,
  starlette,
  structlog,
}:

buildPythonPackage (finalAttrs: {
  pname = "langgraph-runtime-inmem";
  version = "0.22.1";
  pyproject = true;

  # Not available in any repository
  src = fetchPypi {
    pname = "langgraph_runtime_inmem";
    inherit (finalAttrs) version;
    hash = "sha256-u9mDl13Dcq1c1SiCY9NHFzKw3/K6s8b0Hl/ls6OOoe4=";
  };

  build-system = [ hatchling ];

  dependencies = [
    blockbuster
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
