{
  lib,
  buildPythonPackage,
  fetchPypi,
  llama-index-agent-openai,
  llama-index-core,
  llama-index-llms-openai,
  poetry-core,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "llama-index-program-openai";
  version = "0.1.6";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    pname = "llama_index_program_openai";
    inherit version;
    hash = "sha256-xqSYDF6oJgiLKLTe4zZ+2yAiHm0F6w4FAZBJGQEx13I=";
  };

  pythonRelaxDeps = [ "llama-index-agent-openai" ];

  build-system = [ poetry-core ];


  dependencies = [
    llama-index-agent-openai
    llama-index-core
    llama-index-llms-openai
  ];

  pythonImportsCheck = [ "llama_index.program.openai" ];

  meta = with lib; {
    description = "LlamaIndex Program Integration for OpenAI";
    homepage = "https://github.com/run-llama/llama_index/tree/main/llama-index-integrations/program/llama-index-program-openai";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
