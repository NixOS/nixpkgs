{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  agate,
  dbt-adapters,
  dbt-common,
  dbt-core,
  google-cloud-bigquery,
  google-cloud-dataproc,
  google-cloud-storage,

  # tests
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "dbt-bigquery";
  version = "1.9.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "dbt-labs";
    repo = "dbt-bigquery";
    tag = "v${version}";
    hash = "sha256-YZA8lcUGoq5jMNS1GlbBd036X2F3khsZWr5Pv65zpPI=";
  };

  pythonRelaxDeps = [
    "agate"
    "google-cloud-storage"
  ];

  build-system = [
    setuptools
  ];

  dependencies = [
    agate
    dbt-adapters
    dbt-common
    dbt-core
    google-cloud-bigquery
    google-cloud-dataproc
    google-cloud-storage
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  enabledTestPaths = [ "tests/unit" ];

  pythonImportsCheck = [ "dbt.adapters.bigquery" ];

  meta = {
    description = "Plugin enabling dbt to operate on a BigQuery database";
    homepage = "https://github.com/dbt-labs/dbt-bigquery";
    changelog = "https://github.com/dbt-labs/dbt-bigquery/blob/${version}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ tjni ];
  };
}
