{
  lib,
  buildPythonPackage,
  click,
  dateutils,
  fetchFromGitHub,
  hatchling,
  hypothesis,
  importlib-metadata,
  jinja2,
  jsonschema,
  more-itertools,
  pydantic,
  pytestCheckHook,
  pyyaml,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "dbt-semantic-interfaces";
  version = "0.10.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "dbt-labs";
    repo = "dbt-semantic-interfaces";
    tag = "v${version}";
    hash = "sha256-uTlz41eIcEqMvD9d9jvn7g9sZs4uEKUdsmZ0fwWkIuY=";
  };

  pythonRelaxDeps = [ "importlib-metadata" ];

  build-system = [
    hatchling
  ];

  dependencies = [
    click
    dateutils
    importlib-metadata
    jinja2
    jsonschema
    more-itertools
    pydantic
    pyyaml
    typing-extensions
  ];

  nativeCheckInputs = [
    pytestCheckHook
    hypothesis
  ];

  pythonImportsCheck = [ "dbt_semantic_interfaces" ];

  meta = {
    description = "Shared interfaces used by dbt-core and MetricFlow projects";
    homepage = "https://github.com/dbt-labs/dbt-semantic-interfaces";
    changelog = "https://github.com/dbt-labs/dbt-semantic-interfaces/releases/tag/${src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ pbsds ];
  };
}
