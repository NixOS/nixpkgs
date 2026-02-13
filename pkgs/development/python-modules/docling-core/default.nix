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

buildPythonPackage (finalAttrs: {
  pname = "docling-core";
  version = "2.64.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "docling-project";
    repo = "docling-core";
    tag = "v${finalAttrs.version}";
    hash = "sha256-22UJuHKUKyaIXcFOJvBWZibxBpibENZqVVFmZalWGx0=";
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
    changelog = "https://github.com/docling-project/docling-core/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    description = "Python library to define and validate data types in Docling";
    homepage = "https://github.com/docling-project/docling-core";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
