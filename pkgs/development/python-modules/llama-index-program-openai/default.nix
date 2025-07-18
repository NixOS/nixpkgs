{
  lib,
  buildPythonPackage,
  fetchPypi,
  hatchling,
  llama-index-agent-openai,
  llama-index-core,
  llama-index-llms-openai,
}:

buildPythonPackage rec {
  pname = "llama-index-program-openai";
  version = "0.3.2";
  pyproject = true;

  src = fetchPypi {
    pname = "llama_index_program_openai";
    inherit version;
    hash = "sha256-BMlZouYWSJiUvS7uu5lQDW8cF9WIw9oN3HXr0+t0Ue4=";
  };

  pythonRelaxDeps = [ "llama-index-agent-openai" ];

  build-system = [ hatchling ];

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
