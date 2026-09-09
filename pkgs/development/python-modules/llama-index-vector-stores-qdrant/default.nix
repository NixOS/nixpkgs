{
  lib,
  buildPythonPackage,
  fetchPypi,
  grpcio,
  hatchling,
  llama-index-core,
  qdrant-client,
}:

buildPythonPackage (finalAttrs: {
  pname = "llama-index-vector-stores-qdrant";
  version = "0.10.3";
  pyproject = true;

  src = fetchPypi {
    pname = "llama_index_vector_stores_qdrant";
    inherit (finalAttrs) version;
    hash = "sha256-S3t/6kLcpFNhbHbo/LcsyqctVSf1N3SlSVdJJ/PDzyY=";
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
})
