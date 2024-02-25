{ lib
, buildPythonPackage
, fetchFromGitHub
, llama-index-core
, llama-parse
, poetry-core
}:

buildPythonPackage rec {
  pname = "llama-index-readers-llama-parse";

  inherit (llama-index-core) version src meta;

  pyproject = true;

  sourceRoot = "${src.name}/llama-index-integrations/readers/${pname}";

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    llama-parse
    llama-index-core
  ];

  pythonImportsCheck = [
    "llama_index.readers.llama_parse"
  ];
}
