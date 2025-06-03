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
  version = "0.4.8";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    pname = "llama_index_agent_openai";
    inherit version;
    hash = "sha256-unbyHht/D2bjJtxBnCzEA8u2FK4o95BFQLEQNpWWX2g=";
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
