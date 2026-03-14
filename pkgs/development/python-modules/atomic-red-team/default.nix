{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hypothesis,
  jsonschema,
  poetry-core,
  pydantic,
  pytestCheckHook,
  pyyaml,
  requests,
  ruamel-yaml,
  typer,
}:

buildPythonPackage (finalAttrs: {
  pname = "atomic-red-team";
  version = "0.1.0-unstable-2026-01-20";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "redcanaryco";
    repo = "atomic-red-team";
    rev = "a1e6fd545421d6acf4e97d9c6737de31512cb41a";
    hash = "sha256-ZOmQ5NEn4ZTUQ3/fytGfWYqpHluWc8BwC7wBnYysyLU=";
  };

  pythonRelaxDeps = [
    "hypothesis"
    "jsonschema"
    "pydantic"
    "pytest"
  ];

  build-system = [ poetry-core ];

  dependencies = [
    hypothesis
    jsonschema
    pydantic
    pyyaml
    requests
    ruamel-yaml
    typer
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "atomic_red_team" ];

  meta = {
    description = "Detection tests based on MITRE's ATT&CK";
    homepage = "https://github.com/redcanaryco/atomic-red-team";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
