{ lib
, buildPythonPackage
, fetchFromGitHub
, llama-index-agent-openai
, llama-index-core
, llama-index-llms-openai
, poetry-core
}:

buildPythonPackage rec {
  pname = "llama-index-program-openai";

  inherit (llama-index-core) version src meta;

  pyproject = true;

  sourceRoot = "${src.name}/llama-index-integrations/program/${pname}";

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    llama-index-agent-openai
    llama-index-core
    llama-index-llms-openai
  ];

  pythonImportsCheck = [
    "llama_index.program.openai"
  ];
}
