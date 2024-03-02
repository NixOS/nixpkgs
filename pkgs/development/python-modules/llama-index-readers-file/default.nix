{ lib
, beautifulsoup4
, buildPythonPackage
, fetchFromGitHub
, llama-index-core
, poetry-core
, pymupdf
, pypdf
, pythonRelaxDepsHook
}:

buildPythonPackage rec {
  pname = "llama-index-readers-file";

  inherit (llama-index-core) version src meta;

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

  pythonImportsCheck = [
    "llama_index.readers.file"
  ];
}
