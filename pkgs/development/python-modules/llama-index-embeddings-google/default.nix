{
  lib,
  buildPythonPackage,
  fetchPypi,
  google-generativeai,
  llama-index-core,
  hatchling,
}:

buildPythonPackage (finalAttrs: {
  pname = "llama-index-embeddings-google";
  version = "0.4.2";
  pyproject = true;

  src = fetchPypi {
    pname = "llama_index_embeddings_google";
    inherit (finalAttrs) version;
    hash = "sha256-dWV2fKudLsxfpHTGrGljMBU62vYUqzf8NarQ3Nl9poI=";
  };

  pythonRelaxDeps = [ "google-generativeai" ];

  build-system = [ hatchling ];

  dependencies = [
    google-generativeai
    llama-index-core
  ];

  # Tests are only available in the mono repo
  doCheck = false;

  pythonImportsCheck = [ "llama_index.embeddings.google" ];

  meta = {
    description = "LlamaIndex Embeddings Integration for Google";
    homepage = "https://github.com/run-llama/llama_index/tree/main/llama-index-integrations/embeddings/llama-index-embeddings-google";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
