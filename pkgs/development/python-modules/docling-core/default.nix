{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  jsonref,
  jsonschema,
  pandas,
  pillow,
  pydantic,
  tabulate,
  jsondiff,
  requests,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "docling-core";
  version = "2.14.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "DS4SD";
    repo = "docling-core";
    tag = "v${version}";
    hash = "sha256-Iz3w8dGmpnAIVMGbvmaB/nl2fXIuX0flKCrZy4VJ0Q4=";
  };

  build-system = [
    poetry-core
  ];

  dependencies = [
    jsonref
    jsonschema
    pandas
    pillow
    pydantic
    tabulate
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

  meta = {
    changelog = "https://github.com/DS4SD/docling-core/blob/${src.tag}/CHANGELOG.md";
    description = "Python library to define and validate data types in Docling";
    homepage = "https://github.com/DS4SD/docling-core";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ drupol ];
  };
}
