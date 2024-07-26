{ lib
, buildPythonPackage
, fetchFromGitHub
, llama-index-core
, llama-index-llms-openai
, poetry-core
}:

buildPythonPackage rec {
  pname = "llama-index-agent-openai";

  inherit (llama-index-core) version src meta;

  pyproject = true;

  sourceRoot = "${src.name}/llama-index-integrations/agent/${pname}";

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    llama-index-core
    llama-index-llms-openai
  ];

  pythonImportsCheck = [
    "llama_index.agent.openai"
  ];
}
