{ lib
, buildPythonPackage
, fetchPypi
, llama-index-core
, llama-index-llms-openai
, llama-index-program-openai
, poetry-core
, pythonOlder
}:

buildPythonPackage rec {
  pname = "llama-index-question-gen-openai";
  version = "0.1.3";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    pname = "llama_index_question_gen_openai";
    inherit version;
    hash = "sha256-RIYZgRekVFfS4DauYLk69YBSiTzH14+ptvR91HuB4uE=";
  };

  build-system = [
    poetry-core
  ];

  dependencies = [
    llama-index-core
    llama-index-llms-openai
    llama-index-program-openai
  ];

  # Tests are only available in the mono repo
  doCheck = false;

  pythonImportsCheck = [
    "llama_index.question_gen.openai"
  ];

  meta = with lib; {
    description = "LlamaIndex Question Gen Integration for Openai Generator";
    homepage = "https://github.com/run-llama/llama_index/tree/main/llama-index-integrations/question_gen/llama-index-question-gen-openai";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
