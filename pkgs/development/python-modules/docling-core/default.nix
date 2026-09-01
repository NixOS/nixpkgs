{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  poetry-core,
  setuptools,

  # dependencies
  defusedxml,
  doclang,
  jsonref,
  jsonschema,
  latex2mathml,
  pandas,
  pillow,
  pydantic,
  pydantic-settings,
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
  opencv-python-headless,
  pytestCheckHook,
  requests,
  saxonche,
  universal-pathlib,
}:

buildPythonPackage (finalAttrs: {
  pname = "docling-core";
  version = "2.92.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "docling-project";
    repo = "docling-core";
    tag = "v${finalAttrs.version}";
    hash = "sha256-OD9cB1WaFaQcbRnYJ3wsMROSjTb4Jgy6t3W0pJDO0DA=";
  };

  build-system = [
    poetry-core
    setuptools
  ];

  pythonRelaxDeps = [
    "defusedxml"
    "pillow"
    "pydantic-settings"
    "typer"
  ];
  dependencies = [
    defusedxml
    doclang
    jsonref
    jsonschema
    latex2mathml
    pandas
    pillow
    pydantic
    pydantic-settings
    pyyaml
    semchunk
    tabulate
    transformers
    tree-sitter
    typer
    typing-extensions
  ];

  pythonImportsCheck = [ "docling_core" ];

  nativeCheckInputs = [
    gitpython
    jsondiff
    # `ImageRef.from_pil` encodes PNGs with OpenCV when available, and the test
    # reference files are generated with it: https://github.com/docling-project/docling-core/pull/562
    opencv-python-headless
    pytestCheckHook
    requests
    saxonche
    universal-pathlib
  ];

  disabledTestPaths = [
    # attempts to download models
    "test/test_chunk_expander.py"
    "test/test_code_chunker.py"
    "test/test_code_chunking_strategy.py"
    "test/test_hybrid_chunker.py"
    "test/test_line_chunker.py"

    # Requires unpackaged dclq
    "packages/dclq/tests/test_cli.py"
  ];

  meta = {
    description = "Python library to define and validate data types in Docling";
    homepage = "https://github.com/docling-project/docling-core";
    changelog = "https://github.com/docling-project/docling-core/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
