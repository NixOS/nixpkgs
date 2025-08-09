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

buildPythonPackage rec {
  pname = "langgraph-runtime-inmem";
  version = "0.6.8";
  pyproject = true;

  # Not available in any repository
  src = fetchPypi {
    pname = "langgraph_runtime_inmem";
    inherit version;
    hash = "sha256-chPmwJ+tUJoRK5xX9+r6mbYf95ZbX4Z3mP6Ra19nBxM=";
  };

  build-system = [
    hatchling
  ];

  dependencies = [
    blockbuster
    langgraph
    langgraph-checkpoint
    sse-starlette
    starlette
    structlog
  ];

  # Can remove after blockbuster version bump
  # https://github.com/NixOS/nixpkgs/pull/431547
  pythonRelaxDeps = [
    "blockbuster"
  ];

  pythonImportsCheck = [
    "langgraph_runtime_inmem"
  ];

  # no tests
  doCheck = false;

  meta = {
    description = "Inmem implementation for the LangGraph API server";
    homepage = "https://pypi.org/project/langgraph-runtime-inmem/";
    # no changelog
    license = lib.licenses.elastic20;
    maintainers = with lib.maintainers; [ sarahec ];
  };
}
