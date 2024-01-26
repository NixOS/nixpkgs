{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, click
, dateutils
, hatchling
, importlib-metadata
, jinja2
, jsonschema
, more-itertools
, pydantic
, pyyaml
, typing-extensions
, hypothesis
, dbt-postgres
}:

buildPythonPackage rec {
  pname = "dbt-semantic-interfaces";
  version = "0.4.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "dbt-labs";
    repo = "dbt-semantic-interfaces";
    rev = "refs/tags/v${version}";
    hash = "sha256-mYAOAi0Qb89zp4o7vRdR7fw7vrlXt1TFVqGR09QcRSA=";
  };

  propagatedBuildInputs = [
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

  nativeBuildInputs = [
    hatchling
  ];

  nativeCheckInputs = [
    pytestCheckHook
    hypothesis
  ];

  pythonImportsCheck = [
    "dbt_semantic_interfaces"
  ];

  meta = with lib; {
    changelog = "https://github.com/dbt-labs/dbt-semantic-interfaces/releases/tag/v${version}";
    description = "shared interfaces used by dbt-core and MetricFlow projects";
    homepage = "https://github.com/dbt-labs/dbt-semantic-interfaces";
    license = licenses.asl20;
    maintainers = with maintainers; [ pbsds ];
  };
}
