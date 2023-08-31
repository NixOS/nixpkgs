{ lib
, buildPythonPackage
, click
, fetchFromGitHub
, hatchling
, importlib-metadata
, jinja2
, jsonschema
, more-itertools
, pydantic
, pytestCheckHook
, python-dateutil
, pythonOlder
, pythonRelaxDepsHook
, pyyaml
, typing-extensions
}:

buildPythonPackage rec {
  pname = "dbt-semantic-interfaces";
  version = "0.2.0";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "dbt-labs";
    repo = "dbt-semantic-interfaces";
    rev = "refs/tags/v${version}";
    hash = "sha256-15AKR71igfvnQZ09MxG3bq/dbv9ak9i9aRAlUlS4x/g=";
  };

  pythonRelaxDeps = [
    "jsonschema"
    "more-itertools"
  ];

  nativeBuildInputs = [
    hatchling
    pythonRelaxDepsHook
  ];

  propagatedBuildInputs = [
    click
    importlib-metadata
    jinja2
    jsonschema
    more-itertools
    pydantic
    python-dateutil
    pyyaml
    typing-extensions
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "dbt_semantic_interfaces"
  ];

  meta = with lib; {
    description = "The shared semantic layer definitions that dbt-core and MetricFlow use";
    homepage = "https://github.com/dbt-labs/dbt-semantic-interfaces";
    changelog = "https://github.com/dbt-labs/dbt-semantic-interfaces/blob/${src.rev}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
