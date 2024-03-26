{ lib
, beautifulsoup4
, buildPythonPackage
, fetchFromGitHub
, llama-index-core
, poetry-core
, pymupdf
, pypdf
, pytestCheckHook
, pythonRelaxDepsHook
}:

buildPythonPackage rec {
  pname = "llama-index-readers-file";
  version = "0.1.7";

  inherit (llama-index-core) src meta;

  pyproject = true;

  sourceRoot = "${src.name}/llama-index-integrations/readers/${pname}";

  pythonRelaxDeps = [
    "beautifulsoup4"
    "pymupdf"
    "pypdf"
  ];

  pythonRemoveDeps = [
    "bs4"
  ];

  nativeBuildInputs = [
    poetry-core
    pythonRelaxDepsHook
  ];

  propagatedBuildInputs = [
    beautifulsoup4
    llama-index-core
    pymupdf
    pypdf
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "llama_index.readers.file"
  ];
}
