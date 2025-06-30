{
  lib,
  buildPythonPackage,
  fetchPypi,
  hatchling,
  llama-index-core,
  llama-index-llms-openai,
  llama-index-program-openai,
}:

buildPythonPackage rec {
  pname = "llama-index-question-gen-openai";
  version = "0.3.1";
  pyproject = true;

  src = fetchPypi {
    pname = "llama_index_question_gen_openai";
    inherit version;
    hash = "sha256-XpMRtDPMJYH/ilMfoZ+zqiGBW6/3WqrN7xF2CslSKqk=";
  };

  build-system = [ hatchling ];

  dependencies = [
    llama-index-core
    llama-index-llms-openai
    llama-index-program-openai
  ];

  # Tests are only available in the mono repo
  doCheck = false;

  pythonImportsCheck = [ "llama_index.question_gen.openai" ];

  meta = with lib; {
    description = "LlamaIndex Question Gen Integration for Openai Generator";
    homepage = "https://github.com/run-llama/llama_index/tree/main/llama-index-integrations/question_gen/llama-index-question-gen-openai";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
