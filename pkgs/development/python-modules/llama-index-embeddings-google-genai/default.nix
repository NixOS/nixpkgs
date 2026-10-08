{
  lib,
  buildPythonPackage,
  fetchPypi,
  hatchling,
  llama-index-core,
  google-genai,
}:

buildPythonPackage (finalAttrs: {
  pname = "llama-index-embeddings-google-genai";
  version = "0.5.1";
  pyproject = true;

  src = fetchPypi {
    pname = "llama_index_embeddings_google_genai";
    inherit (finalAttrs) version;
    hash = "sha256-xA0J65uYGUnbWaNh0yJ0U8IumOnhjTXHK9Jklnvd2UQ=";
  };

  build-system = [ hatchling ];

  dependencies = [
    llama-index-core
    google-genai
  ];

  # Tests are only available in the mono repo
  doCheck = false;

  pythonImportsCheck = [ "llama_index.embeddings.google_genai" ];

  meta = {
    description = "LlamaIndex Embeddings Integration for Google GenAI";
    homepage = "https://github.com/run-llama/llama_index/tree/main/llama-index-integrations/embeddings/llama-index-embeddings-google-genai";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
