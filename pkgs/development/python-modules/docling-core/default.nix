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
  version = "2.3.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "DS4SD";
    repo = "docling-core";
    rev = "refs/tags/v${version}";
    hash = "sha256-N8rL+5bCVF4Qi5eqgkaB2r3LTYoqTVPeK4gQ6stiW/w=";
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
    changelog = "https://github.com/DS4SD/docling-core/blob/${version}/CHANGELOG.md";
    description = "Python library to define and validate data types in Docling";
    homepage = "https://github.com/DS4SD/docling-core";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ drupol ];
  };
}
