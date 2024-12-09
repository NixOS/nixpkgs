{
  lib,
  buildPythonPackage,
  fetchPypi,
  google-generativeai,
  llama-index-core,
  poetry-core,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "llama-index-embeddings-gemini";
  version = "0.3.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    pname = "llama_index_embeddings_gemini";
    inherit version;
    hash = "sha256-vytKBvvNVbW1GpFS9+0ydkyUqih3UUGusRIp79hMjtI=";
  };

  pythonRelaxDeps = [ "google-generativeai" ];

  build-system = [ poetry-core ];


  dependencies = [
    google-generativeai
    llama-index-core
  ];

  # Tests are only available in the mono repo
  doCheck = false;

  pythonImportsCheck = [ "llama_index.embeddings.gemini" ];

  meta = with lib; {
    description = "LlamaIndex Llms Integration for Gemini";
    homepage = "https://github.com/run-llama/llama_index/tree/main/llama-index-integrations/embeddings/llama-index-embeddings-gemini";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
