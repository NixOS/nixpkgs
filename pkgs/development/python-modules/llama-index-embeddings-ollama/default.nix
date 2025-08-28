{
  lib,
  buildPythonPackage,
  fetchPypi,
  llama-index-core,
  ollama,
  hatchling,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "llama-index-embeddings-ollama";
  version = "0.7.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    pname = "llama_index_embeddings_ollama";
    inherit version;
    hash = "sha256-StV3rCFInL4oi/YEytu9s1a9rx9qdC7MG6uN855pOvQ=";
  };

  pythonRelaxDeps = [ "ollama" ];

  build-system = [ hatchling ];

  dependencies = [
    llama-index-core
    ollama
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
