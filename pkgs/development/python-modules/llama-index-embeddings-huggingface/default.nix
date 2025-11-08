{
  lib,
  buildPythonPackage,
  fetchPypi,
  llama-index-core,
  hatchling,
  pythonOlder,
  sentence-transformers,
}:

buildPythonPackage rec {
  pname = "llama-index-embeddings-huggingface";
  version = "0.6.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    pname = "llama_index_embeddings_huggingface";
    inherit version;
    hash = "sha256-OyH/7aIvgiHtVXeLs9rtcWZKsHs0Hx3S9AiWO9IDVbk=";
  };

  build-system = [ hatchling ];

  dependencies = [
    llama-index-core
    sentence-transformers
  ];

  # Tests are only available in the mono repo
  doCheck = false;

  pythonImportsCheck = [ "llama_index.embeddings.huggingface" ];

  meta = with lib; {
    description = "LlamaIndex Embeddings Integration for Huggingface";
    homepage = "https://github.com/run-llama/llama_index/tree/main/llama-index-integrations/embeddings/llama-index-embeddings-huggingface";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
