{ lib
, buildPythonPackage
, fetchFromGitHub
, llama-index-core
, llama-index-llms-openai
, poetry-core
}:

buildPythonPackage rec {
  pname = "llama-index-multi-modal-llms-openai";

  inherit (llama-index-core) version src meta;

  pyproject = true;

  sourceRoot = "${src.name}/llama-index-integrations/multi_modal_llms/${pname}";

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    llama-index-core
    llama-index-llms-openai
  ];

  pythonImportsCheck = [
    "llama_index.multi_modal_llms.openai"
  ];
}
