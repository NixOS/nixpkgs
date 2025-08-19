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
  typer,
  typing-extensions,

  # tests
  jsondiff,
  pytestCheckHook,
  requests,
}:

buildPythonPackage rec {
  pname = "docling-core";
  version = "2.44.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "docling-project";
    repo = "docling-core";
    tag = "v${version}";
    hash = "sha256-CLPJYt3P6DUt0lQQOQ54vXPJcoi3Kyq7eZ6OwjGkmGk=";
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
    jsondiff
    pytestCheckHook
    requests
  ];

  disabledTestPaths = [
    # attempts to download models
    "test/test_hybrid_chunker.py"
  ];

  meta = {
    changelog = "https://github.com/DS4SD/docling-core/blob/${src.tag}/CHANGELOG.md";
    description = "Python library to define and validate data types in Docling";
    homepage = "https://github.com/DS4SD/docling-core";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ drupol ];
  };
}
