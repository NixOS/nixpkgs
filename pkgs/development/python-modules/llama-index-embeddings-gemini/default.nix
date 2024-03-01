{ lib
, buildPythonPackage
, fetchFromGitHub
, google-generativeai
, llama-index-core
, poetry-core
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "llama-index-embeddings-gemini";
  version = "0.1.3";

  inherit (llama-index-core) src meta;

  pyproject = true;

  sourceRoot = "${src.name}/llama-index-integrations/embeddings/${pname}";

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    google-generativeai
    llama-index-core
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "llama_index.embeddings.gemini"
  ];
}
