{
  lib,
  buildPythonPackage,
  fetchPypi,
  hatchling,
  llama-index-core,
  ollama,
  pytest-asyncio,
}:

buildPythonPackage rec {
  pname = "llama-index-embeddings-ollama";
  version = "0.8.6";
  pyproject = true;

  src = fetchPypi {
    pname = "llama_index_embeddings_ollama";
    inherit version;
    hash = "sha256-szwgaHLLM9vdu63lPSeKbXcSUUMAbds3K/PtY8MEuXU=";
  };

  pythonRelaxDeps = [ "ollama" ];

  build-system = [ hatchling ];

  dependencies = [
    llama-index-core
    ollama
    pytest-asyncio
  ];

  # Tests are only available in the mono repo
  doCheck = false;

  pythonImportsCheck = [ "llama_index.embeddings.ollama" ];

  meta = {
    description = "LlamaIndex Llms Integration for Ollama";
    homepage = "https://github.com/run-llama/llama_index/tree/main/llama-index-integrations/embeddings/llama-index-embeddings-ollama";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
