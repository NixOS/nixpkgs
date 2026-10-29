{
  lib,
  buildPythonPackage,
  faiss,
  fetchPypi,
  hatchling,
  llama-index-core,
}:

buildPythonPackage (finalAttrs: {
  pname = "llama-index-vector-stores-faiss";
  version = "0.6.0";
  pyproject = true;

  src = fetchPypi {
    pname = "llama_index_vector_stores_faiss";
    inherit (finalAttrs) version;
    hash = "sha256-AL/rbLdXHg6FZWbLTxDIm0FbYQjxUdmtSO6cMdpWP14=";
  };

  build-system = [ hatchling ];

  dependencies = [
    faiss
    llama-index-core
  ];

  pythonImportsCheck = [ "llama_index.vector_stores.faiss" ];

  meta = {
    description = "LlamaIndex Vector Store Integration for Faiss";
    homepage = "https://github.com/run-llama/llama_index/tree/main/llama-index-integrations/vector_stores/llama-index-vector-stores-faiss";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      fab
      kilyanni
    ];
  };
})
