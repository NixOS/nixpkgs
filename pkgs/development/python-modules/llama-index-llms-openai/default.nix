{
  lib,
  buildPythonPackage,
  fetchPypi,
  llama-index-core,
  openai,
  hatchling,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "llama-index-llms-openai";
  version = "0.4.7";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    pname = "llama_index_llms_openai";
    inherit version;
    hash = "sha256-Vkr4qzn7Pzrf6uc6WcDcpGwJmrhEoo5yXu4MVR1Iafg=";
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

  meta = with lib; {
    description = "LlamaIndex LLMS Integration for OpenAI";
    homepage = "https://github.com/run-llama/llama_index/tree/main/llama-index-integrations/llms/llama-index-llms-openai";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
