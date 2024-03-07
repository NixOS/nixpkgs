{ lib
, buildPythonPackage
, fetchFromGitHub
, llama-index-core
, llama-index-embeddings-openai
, llama-index-llms-openai
, llama-index-vector-stores-chroma
, poetry-core
}:

buildPythonPackage rec {
  pname = "llama-index-cli";

  inherit (llama-index-core) version src meta;

  pyproject = true;

  sourceRoot = "${src.name}/${pname}";

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    llama-index-core
    llama-index-embeddings-openai
    llama-index-llms-openai
    llama-index-vector-stores-chroma
  ];

  pythonImportsCheck = [
    "llama_index.cli"
  ];
}
