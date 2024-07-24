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
  pname = "llama-index-vector-stores-google";
  version = "0.1.5";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    pname = "llama_index_vector_stores_google";
    inherit version;
    hash = "sha256-E6RNf2DzktoZW89P0VKfmeZ5SEslGkyFLRxVtnsQOYc=";
  };

  pythonRelaxDeps = [ "google-generativeai" ];

  build-system = [
    poetry-core
  ];

  dependencies = [
    google-generativeai
    llama-index-core
  ];

  pythonImportsCheck = [ "llama_index.vector_stores.google" ];

  meta = with lib; {
    description = "LlamaIndex Vector Store Integration for Google";
    homepage = "https://github.com/run-llama/llama_index/tree/main/llama-index-integrations/vector_stores/llama-index-vector-stores-google";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
