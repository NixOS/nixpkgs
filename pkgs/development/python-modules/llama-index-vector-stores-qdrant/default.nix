{
  lib,
  buildPythonPackage,
  fetchPypi,
  grpcio,
  hatchling,
  llama-index-core,
  qdrant-client,
}:

buildPythonPackage rec {
  pname = "llama-index-vector-stores-qdrant";
  version = "0.9.2";
  pyproject = true;

  src = fetchPypi {
    pname = "llama_index_vector_stores_qdrant";
    inherit version;
    hash = "sha256-x/gTig9Peb7XmjK3yHXSdmhJsCp3lhflW40f6xqeYFo=";
  };

  build-system = [ hatchling ];

  dependencies = [
    grpcio
    llama-index-core
    qdrant-client
  ];

  pythonImportsCheck = [ "llama_index.vector_stores.qdrant" ];

  meta = {
    description = "LlamaIndex Vector Store Integration for Qdrant";
    homepage = "https://github.com/run-llama/llama_index/tree/main/llama-index-integrations/vector_stores/llama-index-vector-stores-qdrant";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
