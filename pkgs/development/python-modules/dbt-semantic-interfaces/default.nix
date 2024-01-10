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
}:

buildPythonPackage rec {
  pname = "dbt-semantic-interfaces";
  version = "0.2.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "dbt-labs";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-pnhmfj349uMjSsmdr53dY1Xur6huRKHiXWI7DXYK1gE=";
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
