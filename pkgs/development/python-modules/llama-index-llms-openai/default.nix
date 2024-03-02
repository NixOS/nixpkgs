{ lib
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, llama-index-core
}:

buildPythonPackage rec {
  pname = "llama-index-llms-openai";

  inherit (llama-index-core) version src meta;

  pyproject = true;

  sourceRoot = "${src.name}/llama-index-integrations/llms/${pname}";

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    llama-index-core
  ];

  pythonImportsCheck = [
    "llama_index.llms.openai"
  ];
}
