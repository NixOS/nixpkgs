{ lib
, buildPythonPackage
, fetchFromGitHub
, google-generativeai
, llama-index-core
, poetry-core
}:

buildPythonPackage rec {
  pname = "llama-index-embeddings-google";

  inherit (llama-index-core) version src meta;

  pyproject = true;

  sourceRoot = "${src.name}/llama-index-integrations/embeddings/${pname}";

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    google-generativeai
    llama-index-core
  ];

  pythonImportsCheck = [
    "llama_index.embeddings.google"
  ];
}
