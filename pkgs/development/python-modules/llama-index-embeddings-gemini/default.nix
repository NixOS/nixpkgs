{
  lib,
  buildPythonPackage,
  fetchPypi,
  google-generativeai,
  llama-index-core,
  hatchling,
}:

buildPythonPackage (finalAttrs: {
  pname = "llama-index-embeddings-gemini";
  version = "0.4.2";
  pyproject = true;

  src = fetchPypi {
    pname = "llama_index_embeddings_gemini";
    inherit (finalAttrs) version;
    hash = "sha256-GY983cmRtwir+2q0qyJW5iFmK+96ed5lu6pKHcUm/4g=";
  };

  pythonRelaxDeps = [ "google-generativeai" ];

  build-system = [ hatchling ];

  dependencies = [
    google-generativeai
    llama-index-core
  ];

  # Tests are only available in the mono repo
  doCheck = false;

  pythonImportsCheck = [ "llama_index.embeddings.gemini" ];

  meta = {
    description = "LlamaIndex Llms Integration for Gemini";
    homepage = "https://github.com/run-llama/llama_index/tree/main/llama-index-integrations/embeddings/llama-index-embeddings-gemini";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
