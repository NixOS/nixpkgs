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
  requests,
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
  saxonche,
  universal-pathlib,
}:

buildPythonPackage (finalAttrs: {
  pname = "docling-core";
  version = "2.105.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "docling-project";
    repo = "docling-core";
    tag = "v${finalAttrs.version}";
    hash = "sha256-1e98ahll1NI6tklVmglTtbKzEFNQNqkniG5NhlcQ3d8=";
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
    requests
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
    saxonche
    universal-pathlib
  ];

  disabledTestPaths = [
    # attempts to download models
    "tests/test_chunk_expander.py"
    "tests/test_code_chunker.py"
    "tests/test_code_chunking_strategy.py"
    "tests/test_hybrid_chunker.py"
    "tests/test_line_chunker.py"

    # Requires unpackaged dclq
    "packages/dclq/tests/test_cli.py"
  ];

  # test_connect_time_validation_connects_to_validated_address binds a local socket
  __darwinAllowLocalNetworking = true;

  meta = {
    description = "Python library to define and validate data types in Docling";
    homepage = "https://github.com/docling-project/docling-core";
    changelog = "https://github.com/docling-project/docling-core/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
