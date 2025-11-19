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
  version = "0.8.4";
  pyproject = true;

  src = fetchPypi {
    pname = "llama_index_embeddings_ollama";
    inherit version;
    hash = "sha256-bahglDEI13W04ZFFCND2Vnht0BcKakU+CX7iuMKf6yA=";
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

  meta = with lib; {
    description = "LlamaIndex Llms Integration for Ollama";
    homepage = "https://github.com/run-llama/llama_index/tree/main/llama-index-integrations/embeddings/llama-index-embeddings-ollama";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
