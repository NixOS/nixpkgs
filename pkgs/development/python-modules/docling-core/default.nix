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
  version = "2.16.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "DS4SD";
    repo = "docling-core";
    tag = "v${version}";
    hash = "sha256-oW/jX9IHCpztc0FDm8/3OzDmOxM92jrkFq/JeAcI9ZA=";
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
    # semchunk
    typer
    latex2mathml
  ];

  pythonRelaxDeps = [
    "pillow"
  ];

  pythonImportsCheck = [
    "docling_core"
  ];

  doCheck = false;

  nativeCheckInputs = [
    jsondiff
    pytestCheckHook
    requests
  ];

  meta = {
    changelog = "https://github.com/DS4SD/docling-core/blob/${version}/CHANGELOG.md";
    description = "Python library to define and validate data types in Docling";
    homepage = "https://github.com/DS4SD/docling-core";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ drupol ];
  };
}
