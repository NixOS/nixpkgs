{
  lib,
  boto3,
  buildPythonPackage,
  fetchPypi,
  hatchling,
  llama-index-core,
}:

buildPythonPackage (finalAttrs: {
  pname = "llama-index-graph-stores-neptune";
  version = "0.6.0";
  pyproject = true;

  src = fetchPypi {
    pname = "llama_index_graph_stores_neptune";
    inherit (finalAttrs) version;
    hash = "sha256-qYr9WcQvGrq4juuZk2Ww8IK9uxnS9Th00fB4Dmh7Irc=";
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
})
