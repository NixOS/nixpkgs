{
  lib,
  agate,
  buildPythonPackage,
  dbt-core,
  fetchFromGitHub,
  google-cloud-bigquery,
  google-cloud-dataproc,
  google-cloud-storage,
  pytestCheckHook,
  pythonOlder,
  setuptools,
  urllib3,
}:

buildPythonPackage rec {
  pname = "dbt-bigquery";
  version = "1.8.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "dbt-labs";
    repo = "dbt-bigquery";
    rev = "refs/tags/v${version}";
    hash = "sha256-5sqKvYXKBze6t0yNaeYvwyS919CHMXCv3RRzNnBxfec=";
  };

  pythonRelaxDeps = [ "agate" ];

  build-system = [
    setuptools
  ];

  dependencies = [
    agate
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
