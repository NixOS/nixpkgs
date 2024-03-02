{ lib
, buildPythonPackage
, click
, dateutils
, dbt-postgres
, fetchFromGitHub
, hatchling
, hypothesis
, importlib-metadata
, jinja2
, jsonschema
, more-itertools
, pydantic
, pytestCheckHook
, pythonOlder
, pyyaml
, typing-extensions
}:

buildPythonPackage rec {
  pname = "dbt-semantic-interfaces";
  version = "0.4.4";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "dbt-labs";
    repo = "dbt-semantic-interfaces";
    rev = "refs/tags/v${version}";
    hash = "sha256-uvwcnOKjwxEmA+/QRGSRofpoE4jZzmE02mGSDLINrJw=";
  };

  nativeBuildInputs = [
    hatchling
  ];

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
