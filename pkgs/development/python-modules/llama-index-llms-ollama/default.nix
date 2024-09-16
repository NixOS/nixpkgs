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
  pname = "llama-index-llms-ollama";
  version = "0.3.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    pname = "llama_index_llms_ollama";
    inherit version;
    hash = "sha256-8fHR/p6H0LN5BZno0lEz6et+hgRVGYJ9wIHfNLXvcDQ=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    llama-index-core
    ollama
  ];

  # Tests are only available in the mono repo
  doCheck = false;

  pythonImportsCheck = [ "llama_index.llms.ollama" ];

  meta = with lib; {
    description = "LlamaIndex LLMS Integration for ollama";
    homepage = "https://github.com/run-llama/llama_index/tree/main/llama-index-integrations/llms/llama-index-llms-ollama";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
