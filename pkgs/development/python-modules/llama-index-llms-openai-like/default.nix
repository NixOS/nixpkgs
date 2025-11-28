{
  lib,
  buildPythonPackage,
  fetchPypi,
  hatchling,
  llama-index-core,
  llama-index-llms-openai,
  pythonOlder,
  transformers,
}:

buildPythonPackage rec {
  pname = "llama-index-llms-openai-like";
  version = "0.5.3";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    pname = "llama_index_llms_openai_like";
    inherit version;
    hash = "sha256-hL38iLtdnqgGvdG+S0N4NXeBwGN8eMVIJCqshX8WUJA=";
  };

  build-system = [ hatchling ];

  dependencies = [
    llama-index-core
    llama-index-llms-openai
    transformers
  ];

  # Tests are only available in the mono repo
  doCheck = false;

  pythonImportsCheck = [ "llama_index.llms.openai_like" ];

  meta = with lib; {
    description = "LlamaIndex LLMS Integration for OpenAI like";
    homepage = "https://github.com/run-llama/llama_index/tree/main/llama-index-integrations/llms/llama-index-llms-openai-like";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
