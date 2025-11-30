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
  version = "0.5.1";
  pyproject = true;

  src = fetchPypi {
    pname = "llama_index_graph_stores_nebula";
    inherit version;
    hash = "sha256-XTW6XrAbWx8DZgoEoOL2rP2WNuQqQO+hcCWpQSj98ks=";
  };

  build-system = [ hatchling ];

  dependencies = [
    llama-index-core
    nebula3-python
  ];

  pythonImportsCheck = [ "llama_index.graph_stores.nebula" ];

  meta = with lib; {
    description = "LlamaIndex Graph Store Integration for Nebula";
    homepage = "https://github.com/run-llama/llama_index/tree/main/llama-index-integrations/graph_stores/llama-index-graph-stores-nebula";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
