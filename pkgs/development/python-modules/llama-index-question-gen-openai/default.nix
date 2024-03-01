{ lib
, buildPythonPackage
, fetchFromGitHub
, llama-index-core
, llama-index-llms-openai
, llama-index-program-openai
, poetry-core
}:

buildPythonPackage rec {
  pname = "llama-index-question-gen-openai";

  inherit (llama-index-core) version src meta;

  pyproject = true;

  sourceRoot = "${src.name}/llama-index-integrations/question_gen/${pname}";

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    llama-index-core
    llama-index-llms-openai
    llama-index-program-openai
  ];

  pythonImportsCheck = [
    "llama_index.question_gen.openai"
  ];
}
