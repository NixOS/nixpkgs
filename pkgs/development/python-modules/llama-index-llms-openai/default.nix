{
  lib,
  buildPythonPackage,
  fetchPypi,
  llama-index-core,
  openai,
  hatchling,
}:

buildPythonPackage rec {
  pname = "llama-index-llms-openai";
  version = "0.6.11";
  pyproject = true;

  src = fetchPypi {
    pname = "llama_index_llms_openai";
    inherit version;
    hash = "sha256-7hk3FpHGzQD4V6Xa7a4DEBoBv01e+0cxudJYO2bDZEE=";
  };

  pythonRemoveDeps = [
    # Circular dependency
    "llama-index-agent-openai"
  ];

  build-system = [ hatchling ];

  dependencies = [
    llama-index-core
    openai
  ];

  # Tests are only available in the mono repo
  doCheck = false;

  pythonImportsCheck = [ "llama_index.llms.openai" ];

  meta = {
    description = "LlamaIndex LLMS Integration for OpenAI";
    homepage = "https://github.com/run-llama/llama_index/tree/main/llama-index-integrations/llms/llama-index-llms-openai";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
