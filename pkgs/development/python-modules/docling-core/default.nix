{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  # dependencies
  jsonref,
  jsonschema,
  pandas,
  pillow,
  pydantic,
  tabulate,
  pyyaml,
  semchunk,
  typing-extensions,
  transformers,
  typer,
  latex2mathml,
  jsondiff,
  requests,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "docling-core";
  version = "2.17.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "DS4SD";
    repo = "docling-core";
    tag = "v${version}";
    hash = "sha256-JO6WI2juehO825QOO0FkD58OigEoLGOZAnPBOD4b1tI=";
  };

  build-system = [
    poetry-core
  ];

  dependencies = [
    jsonschema
    pydantic
    jsonref
    tabulate
    pandas
    pillow
    pyyaml
    typing-extensions
    transformers
    semchunk
    typer
    latex2mathml
  ];

  pythonRelaxDeps = [
    "pillow"
    "typer"
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
