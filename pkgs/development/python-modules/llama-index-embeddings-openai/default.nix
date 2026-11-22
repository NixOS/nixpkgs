{
  lib,
  buildPythonPackage,
  fetchPypi,
  llama-index-core,
  openai,
  hatchling,
}:

buildPythonPackage (finalAttrs: {
  pname = "llama-index-embeddings-openai";
  version = "0.8.0";
  pyproject = true;

  src = fetchPypi {
    pname = "llama_index_embeddings_openai";
    inherit (finalAttrs) version;
    hash = "sha256-dSFUhBUFy+Nfq/yQ6uJwP1QbtnKk4U4oK5LA1YZz0q0=";
  };

  build-system = [ hatchling ];

  dependencies = [
    llama-index-core
    openai
  ];

  # Tests are only available in the mono repo
  doCheck = false;

  pythonImportsCheck = [ "llama_index.embeddings.openai" ];

  meta = {
    description = "LlamaIndex Embeddings Integration for OpenAI";
    homepage = "https://github.com/run-llama/llama_index/tree/main/llama-index-integrations/readers/llama-index-readers-s3";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
