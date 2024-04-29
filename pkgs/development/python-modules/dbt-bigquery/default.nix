{ lib
, agate
, buildPythonPackage
, dbt-core
, fetchFromGitHub
, google-cloud-bigquery
, google-cloud-dataproc
, google-cloud-storage
, pytestCheckHook
, pythonOlder
, pythonRelaxDepsHook
, setuptools
, urllib3
}:

buildPythonPackage rec {
  pname = "dbt-bigquery";
  version = "1.7.7";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "dbt-labs";
    repo = "dbt-bigquery";
    rev = "refs/tags/v${version}";
    hash = "sha256-+UF49ReSxKQ8ouutOv1b9JcU/6CNk7Yw8f1/tlRvwnU=";
  };

  pythonRelaxDeps = [
    "agate"
  ];

  build-system = [
    pythonRelaxDepsHook
    setuptools
  ];

  dependencies = [
    agate
    dbt-core
    google-cloud-bigquery
    google-cloud-storage
    google-cloud-dataproc
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pytestFlagsArray = [
    "tests/unit"
  ];

  pythonImportsCheck = [
    "dbt.adapters.bigquery"
  ];

  meta = with lib; {
    description = "Plugin enabling dbt to operate on a BigQuery database";
    homepage = "https://github.com/dbt-labs/dbt-bigquery";
    changelog = "https://github.com/dbt-labs/dbt-bigquery/blob/${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ tjni ];
  };
}
