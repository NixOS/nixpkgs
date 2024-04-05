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
  version = "0.2.2";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    pname = "llama_index_agent_openai";
    inherit version;
    hash = "sha256-EgY92TLHQBV5b5c5hsxS14P1H9o45OrXKlbQ/RlZJe4=";
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
