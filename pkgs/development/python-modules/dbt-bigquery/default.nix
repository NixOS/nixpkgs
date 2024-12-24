{
  lib,
  agate,
  buildPythonPackage,
  dbt-adapters,
  dbt-common,
  dbt-core,
  fetchFromGitHub,
  google-cloud-bigquery,
  google-cloud-dataproc,
  google-cloud-storage,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "dbt-bigquery";
  version = "1.9.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "dbt-labs";
    repo = "dbt-bigquery";
    tag = "v${version}";
    hash = "sha256-jn4U01aUpnjBnOJNyzJXPqmXJZc16pSLN9WkRxsC0zo=";
  };

  pythonRelaxDeps = [ "agate" ];

  build-system = [
    setuptools
  ];

  dependencies = [
    agate
    dbt-common
    dbt-adapters
    dbt-core
    google-cloud-bigquery
    google-cloud-storage
    google-cloud-dataproc
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pytestFlagsArray = [ "tests/unit" ];

  pythonImportsCheck = [ "dbt.adapters.bigquery" ];

  meta = with lib; {
    description = "Plugin enabling dbt to operate on a BigQuery database";
    homepage = "https://github.com/dbt-labs/dbt-bigquery";
    changelog = "https://github.com/dbt-labs/dbt-bigquery/blob/${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ tjni ];
  };
}
