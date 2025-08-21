{
  lib,
  buildPythonPackage,
  fetchPypi,
  hatchling,
  llama-index-core,
  llama-index-llms-openai,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "llama-index-agent-openai";
  version = "0.4.12";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    pname = "llama_index_agent_openai";
    inherit version;
    hash = "sha256-0v5T/rac/kV1LttzKL8NJfapBxs8BWeH5mG5Plt0iig=";
  };

  pythonRelaxDeps = [ "llama-index-llms-openai" ];

  build-system = [ hatchling ];

  dependencies = [
    llama-index-core
    llama-index-llms-openai
  ];

  pythonImportsCheck = [ "llama_index.agent.openai" ];

  meta = with lib; {
    description = "LlamaIndex Agent Integration for OpenAI";
    homepage = "https://github.com/run-llama/llama_index/tree/main/llama-index-integrations/agent/llama-index-agent-openai";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
