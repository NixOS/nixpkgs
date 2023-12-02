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
  version = "0.4.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "dbt-labs";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-nl+V8Rtc5FWHIPUkcQmcaex6zwIdzdmEaim59pG497I=";
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
    # https://github.com/dbt-labs/dbt-semantic-interfaces/issues/134
    broken = versionAtLeast pydantic.version "2";
  };
}
