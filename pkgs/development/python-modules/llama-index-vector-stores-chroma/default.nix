{ lib
, buildPythonPackage
, chromadb
, fetchFromGitHub
, llama-index-core
, onnxruntime
, poetry-core
, pythonRelaxDepsHook
, tokenizers
}:

buildPythonPackage rec {
  pname = "llama-index-vector-stores-chroma";

  inherit (llama-index-core) version src meta;

  pyproject = true;

  sourceRoot = "${src.name}/llama-index-integrations/vector_stores/${pname}";

  pythonRelaxDeps = [
    "onnxruntime"
    "tokenizers"
  ];

  nativeBuildInputs = [
    poetry-core
    pythonRelaxDepsHook
  ];

  propagatedBuildInputs = [
    chromadb
    llama-index-core
    onnxruntime
    tokenizers
  ];

  pythonImportsCheck = [
    "llama_index.vector_stores.chroma"
  ];
}
