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
  version = "2.61.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "docling-project";
    repo = "docling-core";
    tag = "v${version}";
    hash = "sha256-D1p6YHWePE9aKOEj81X/nxZQFne0FO7+Rz3vc5Q2i6U=";
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
