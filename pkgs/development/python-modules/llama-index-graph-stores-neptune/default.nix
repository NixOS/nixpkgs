{
  lib,
  boto3,
  buildPythonPackage,
  fetchPypi,
  hatchling,
  llama-index-core,
}:

buildPythonPackage rec {
  pname = "llama-index-graph-stores-neptune";
  version = "0.4.1";
  pyproject = true;

  src = fetchPypi {
    pname = "llama_index_graph_stores_neptune";
    inherit version;
    hash = "sha256-plwDD8NBcYqedEoCeYqEZn1kDQZjDpg94jRZJBPjdU8=";
  };

  build-system = [ hatchling ];

  dependencies = [
    boto3
    llama-index-core
  ];

  pythonImportsCheck = [ "llama_index.graph_stores.neptune" ];

  meta = {
    description = "LlamaIndex Graph Store Integration for Neptune";
    homepage = "https://github.com/run-llama/llama_index/tree/main/llama-index-integrations/graph_stores/llama-index-graph-stores-neptune";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
