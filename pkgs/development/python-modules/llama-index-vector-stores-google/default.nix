{
  lib,
  buildPythonPackage,
  fetchPypi,
  google-generativeai,
  llama-index-core,
  hatchling,
}:

buildPythonPackage (finalAttrs: {
  pname = "llama-index-vector-stores-google";
  version = "0.6.0";
  pyproject = true;

  src = fetchPypi {
    pname = "llama_index_vector_stores_google";
    inherit (finalAttrs) version;
    hash = "sha256-bGxsNAE6tC0bOLfjzn3kY1Se17yh6c7jjk/sgyMPdck=";
  };

  pythonRelaxDeps = [ "google-generativeai" ];

  build-system = [ hatchling ];

  dependencies = [
    google-generativeai
    llama-index-core
  ];

  pythonImportsCheck = [ "llama_index.vector_stores.google" ];

  meta = {
    description = "LlamaIndex Vector Store Integration for Google";
    homepage = "https://github.com/run-llama/llama_index/tree/main/llama-index-integrations/vector_stores/llama-index-vector-stores-google";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
