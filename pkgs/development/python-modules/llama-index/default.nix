{ lib
, buildPythonPackage
, llama-index-agent-openai
, llama-index-cli
, llama-index-core
, llama-index-embeddings-openai
, llama-index-indices-managed-llama-cloud
, llama-index-legacy
, llama-index-llms-openai
, llama-index-multi-modal-llms-openai
, llama-index-program-openai
, llama-index-question-gen-openai
, llama-index-readers-file
, llama-index-readers-llama-parse
, poetry-core
}:

buildPythonPackage rec {
  pname = "llama-index";

  inherit (llama-index-core) version src meta;

  pyproject = true;

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    llama-index-agent-openai
    llama-index-cli
    llama-index-core
    llama-index-embeddings-openai
    llama-index-indices-managed-llama-cloud
    llama-index-legacy
    llama-index-llms-openai
    llama-index-multi-modal-llms-openai
    llama-index-program-openai
    llama-index-question-gen-openai
    llama-index-readers-file
    llama-index-readers-llama-parse
  ];

  pythonImportsCheck = [
    "llama_index"
  ];
}
