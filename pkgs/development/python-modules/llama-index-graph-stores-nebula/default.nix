{
  lib,
  buildPythonPackage,
  fetchPypi,
  hatchling,
  llama-index-core,
  nebula3-python,
}:

buildPythonPackage rec {
  pname = "llama-index-graph-stores-nebula";
  version = "0.6.0";
  pyproject = true;

  src = fetchPypi {
    pname = "llama_index_graph_stores_nebula";
    inherit version;
    hash = "sha256-/LJ161lbY5q8qO/5AK8QK3WE7gx/c9AxgEH9OIrrFEE=";
  };

  build-system = [ hatchling ];

  dependencies = [
    llama-index-core
    nebula3-python
  ];

  pythonImportsCheck = [ "llama_index.graph_stores.nebula" ];

  meta = {
    description = "LlamaIndex Graph Store Integration for Nebula";
    homepage = "https://github.com/run-llama/llama_index/tree/main/llama-index-integrations/graph_stores/llama-index-graph-stores-nebula";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
