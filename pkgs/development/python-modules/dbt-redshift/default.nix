{ lib
, agate
, boto3
, buildPythonPackage
, dbt-core
, dbt-postgres
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
, pythonRelaxDepsHook
, redshift-connector
, setuptools
}:

buildPythonPackage rec {
  pname = "dbt-redshift";
  version = "1.7.7";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "dbt-labs";
    repo = "dbt-redshift";
    rev = "refs/tags/v${version}";
    hash = "sha256-DKqJ/8hEPe9O9YrAjrTL2Gh1lj6QrdtHtd7aarZ7GkQ=";
  };

  pythonRelaxDeps = [
    "boto3"
    "redshift-connector"
  ];

  nativeBuildInputs = [
    pythonRelaxDepsHook
  ];

  build-system = [
    setuptools
  ];

  dependencies = [
    agate
    boto3
    dbt-core
    dbt-postgres
    redshift-connector
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pytestFlagsArray = [
    "tests/unit"
  ];

  pythonImportsCheck = [
    "dbt.adapters.redshift"
  ];

  meta = with lib; {
    description = "Plugin enabling dbt to work with Amazon Redshift";
    homepage = "https://github.com/dbt-labs/dbt-redshift";
    changelog = "https://github.com/dbt-labs/dbt-redshift/blob/${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ tjni ];
  };
}
