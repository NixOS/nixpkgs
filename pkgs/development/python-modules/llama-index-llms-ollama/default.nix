{
  lib,
  buildPythonPackage,
  fetchPypi,
  hatchling,
  llama-index-core,
  ollama,
}:

buildPythonPackage rec {
  pname = "llama-index-llms-ollama";
  version = "0.9.1";
  pyproject = true;

  src = fetchPypi {
    pname = "llama_index_llms_ollama";
    inherit version;
    hash = "sha256-1Yhe1lri4rx0up4//TpbzXxTQe8GcOPZ/iAIgPwZ+aY=";
  };

  build-system = [ hatchling ];

  dependencies = [
    llama-index-core
    ollama
  ];

  # Tests are only available in the mono repo
  doCheck = false;

  pythonImportsCheck = [ "llama_index.llms.ollama" ];

  meta = {
    description = "LlamaIndex LLMS Integration for ollama";
    homepage = "https://github.com/run-llama/llama_index/tree/main/llama-index-integrations/llms/llama-index-llms-ollama";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
