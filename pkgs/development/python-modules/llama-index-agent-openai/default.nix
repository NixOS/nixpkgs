{
  lib,
  buildPythonPackage,
  fetchPypi,
  llama-index-core,
  llama-index-llms-openai,
  poetry-core,
  pythonOlder,
  pythonRelaxDepsHook,
}:

buildPythonPackage rec {
  pname = "llama-index-agent-openai";
  version = "0.2.7";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    pname = "llama_index_agent_openai";
    inherit version;
    hash = "sha256-E85TXwPjLIIXY8AeJq9CIvOYEXhiJBTThoAToZRugSQ=";
  };

  pythonRelaxDeps = [ "llama-index-llms-openai" ];

  build-system = [
    poetry-core
    pythonRelaxDepsHook
  ];

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
