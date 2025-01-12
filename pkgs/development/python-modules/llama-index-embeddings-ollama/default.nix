{
  lib,
  buildPythonPackage,
  fetchPypi,
  llama-index-core,
  ollama,
  poetry-core,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "llama-index-embeddings-ollama";
  version = "0.3.1";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    pname = "llama_index_embeddings_ollama";
    inherit version;
    hash = "sha256-Wj51+hS+fisagpN0FsiAIE3JbhsdJibcW96T8CHntUA=";
  };

  build-system = [ poetry-core ];

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
