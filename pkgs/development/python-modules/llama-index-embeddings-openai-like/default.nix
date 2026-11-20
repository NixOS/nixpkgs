{
  lib,
  buildPythonPackage,
  fetchPypi,
  hatchling,
  llama-index-embeddings-openai,
}:

buildPythonPackage (finalAttrs: {
  pname = "llama-index-embeddings-openai-like";
  version = "0.5.0";
  pyproject = true;

  src = fetchPypi {
    pname = "llama_index_embeddings_openai_like";
    inherit (finalAttrs) version;
    hash = "sha256-wyire4PPLZDMV5F2LN39fn8siY0aI8+8Z99HHXwHGV4=";
  };

  build-system = [ hatchling ];

  dependencies = [ llama-index-embeddings-openai ];

  # Tests are only available in the mono repo
  doCheck = false;

  pythonImportsCheck = [ "llama_index.embeddings.openai_like" ];

  meta = {
    description = "LlamaIndex Embeddings Integration for OpenAI like";
    homepage = "https://github.com/run-llama/llama_index/tree/main/llama-index-integrations/embeddings/llama-index-embeddings-openai-like";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      fab
      kilyanni
    ];
  };
})
