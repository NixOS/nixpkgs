{
  lib,
  buildPythonPackage,
  fetchPypi,
  google-generativeai,
  llama-index-core,
  poetry-core,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "llama-index-embeddings-ollama";
  version = "0.1.2";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    pname = "llama_index_embeddings_ollama";
    inherit version;
    hash = "sha256-qeCAm93S5K2IjySVGe3H49M5x05OA/xaQMMGDcQdR6k=";
  };

  build-system = [ poetry-core ];

  dependencies = [ llama-index-core ];

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
