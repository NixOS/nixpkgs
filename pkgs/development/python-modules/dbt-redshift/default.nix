{
  lib,
  agate,
  boto3,
  buildPythonPackage,
  dbt-core,
  dbt-postgres,
  fetchFromGitHub,
  pytestCheckHook,
  pythonOlder,
  redshift-connector,
  setuptools,
}:

buildPythonPackage rec {
  pname = "dbt-redshift";
  version = "1.9.0";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "dbt-labs";
    repo = "dbt-redshift";
    tag = "v${version}";
    hash = "sha256-ayt5KRH3jAoi7k+0yfk1ZSqG4qsM+zny8tDnWOWO5oA=";
  };

  pythonRelaxDeps = [
    "boto3"
    "redshift-connector"
  ];

  build-system = [ setuptools ];

  dependencies = [
    agate
    boto3
    dbt-core
    dbt-postgres
    redshift-connector
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pytestFlagsArray = [ "tests/unit" ];

  pythonImportsCheck = [ "dbt.adapters.redshift" ];

  meta = with lib; {
    description = "Plugin enabling dbt to work with Amazon Redshift";
    homepage = "https://github.com/dbt-labs/dbt-redshift";
    changelog = "https://github.com/dbt-labs/dbt-redshift/blob/${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ tjni ];
  };
}
