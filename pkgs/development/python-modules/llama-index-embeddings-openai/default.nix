{ lib
, buildPythonPackage
, fetchFromGitHub
, llama-index-core
, poetry-core
}:

buildPythonPackage rec {
  pname = "llama-index-embeddings-openai";

  inherit (llama-index-core) version src meta;

  pyproject = true;

  sourceRoot = "${src.name}/llama-index-integrations/embeddings/${pname}";

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    llama-index-core
  ];

  pythonImportsCheck = [
    "llama_index.embeddings.openai"
  ];
}
