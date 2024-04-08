{ lib
, buildPythonPackage
, fetchFromGitHub
, llama-index-core
, poetry-core
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "llama-index-readers-json";
  version = "0.1.2";

  inherit (llama-index-core) src meta;

  pyproject = true;

  sourceRoot = "${src.name}/llama-index-integrations/readers/${pname}";

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    llama-index-core
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "llama_index.readers.json"
  ];
}
