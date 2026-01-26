{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  poetry-core,
  setuptools,

  # dependencies
  jsonref,
  jsonschema,
  latex2mathml,
  pandas,
  pillow,
  pydantic,
  pyyaml,
  semchunk,
  tabulate,
  transformers,
  tree-sitter,
  typer,
  typing-extensions,

  # tests
  gitpython,
  jsondiff,
  pytestCheckHook,
  requests,
}:

buildPythonPackage rec {
  pname = "docling-core";
  version = "2.60.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "docling-project";
    repo = "docling-core";
    tag = "v${version}";
    hash = "sha256-KrWeh5b3w1dBk3l7S1FpgONWqP9gS6nhbLIly3Nbtvg=";
  };

  build-system = [
    poetry-core
    setuptools
  ];

  dependencies = [
    jsonref
    jsonschema
    latex2mathml
    pandas
    pillow
    pydantic
    pyyaml
    semchunk
    tabulate
    transformers
    tree-sitter
    typer
    typing-extensions
  ];

  pythonRelaxDeps = [
    "pillow"
  ];

  pythonImportsCheck = [
    "docling_core"
  ];

  nativeCheckInputs = [
    gitpython
    jsondiff
    pytestCheckHook
    requests
  ];

  disabledTestPaths = [
    # attempts to download models
    "test/test_code_chunker.py"
    "test/test_code_chunking_strategy.py"
    "test/test_hybrid_chunker.py"
  ];

  meta = {
    changelog = "https://github.com/docling-project/docling-core/blob/${src.tag}/CHANGELOG.md";
    description = "Python library to define and validate data types in Docling";
    homepage = "https://github.com/docling-project/docling-core";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
