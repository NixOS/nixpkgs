{ lib
, agate
, boto3
, buildPythonPackage
, dbt-core
, dbt-postgres
, fetchFromGitHub
, pytestCheckHook
, pythonRelaxDepsHook
, redshift-connector
, setuptools
}:

buildPythonPackage rec {
  pname = "dbt-redshift";
  version = "1.7.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "dbt-labs";
    repo = "dbt-redshift";
    rev = "refs/tags/v${version}";
    hash = "sha256-Ny6Nnb5OhtqSQZ0BMOQrb0ic6i29GVywy3hn3UuVtxE=";
  };

  nativeBuildInputs = [
    pythonRelaxDepsHook
    setuptools
  ];

  pythonRelaxDeps = [
    "boto3"
    "redshift-connector"
  ];

  propagatedBuildInputs = [
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
