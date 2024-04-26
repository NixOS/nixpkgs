{
  lib,
  buildPythonPackage,
  fetchPypi,
  llama-index-core,
  qdrant-client,
  poetry-core,
  grpcio,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "llama-index-vector-stores-qdrant";
  version = "0.2.7";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    pname = "llama_index_vector_stores_qdrant";
    inherit version;
    hash = "sha256-jVkNFNKghukf1H6yRO5nEj3jWzrn51Xm1g5kS5Kd6m0=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    grpcio
    llama-index-core
    qdrant-client
  ];

  pythonImportsCheck = [ "llama_index.vector_stores.qdrant" ];

  meta = with lib; {
    description = "LlamaIndex Vector Store Integration for Qdrant";
    homepage = "https://github.com/run-llama/llama_index/tree/main/llama-index-integrations/vector_stores/llama-index-vector-stores-qdrant";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
