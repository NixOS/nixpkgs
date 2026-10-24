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
  version = "0.7.0";
  pyproject = true;

  src = fetchPypi {
    pname = "llama_index_vector_stores_faiss";
    inherit (finalAttrs) version;
    hash = "sha256-ZTHrDeP72ogqFuRCvu7tWQIJxf16CfLPI1l32U6X/WM=";
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
