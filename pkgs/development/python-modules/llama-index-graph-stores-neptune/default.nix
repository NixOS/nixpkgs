{
  lib,
  boto3,
  buildPythonPackage,
  fetchPypi,
  hatchling,
  llama-index-core,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "llama-index-graph-stores-neptune";
  version = "0.3.3";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    pname = "llama_index_graph_stores_neptune";
    inherit version;
    hash = "sha256-IqY4dEWcbM9371vuZ7C9NlDux9O/j6wF7Hcc4aiBiIE=";
  };

  build-system = [ hatchling ];

  dependencies = [
    boto3
    llama-index-core
  ];

  pythonImportsCheck = [ "llama_index.graph_stores.neptune" ];

  meta = with lib; {
    description = "LlamaIndex Graph Store Integration for Neptune";
    homepage = "https://github.com/run-llama/llama_index/tree/main/llama-index-integrations/graph_stores/llama-index-graph-stores-neptune";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
