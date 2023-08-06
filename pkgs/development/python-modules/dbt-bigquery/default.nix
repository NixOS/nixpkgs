{ lib
, buildPythonPackage
, fetchFromGitHub
, agate
, dbt-core
, google-cloud-bigquery
, google-cloud-storage
, google-cloud-dataproc
, pytestCheckHook
, pythonRelaxDepsHook
}:

buildPythonPackage rec {
  pname = "dbt-bigquery";
  version = "1.5.3";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "dbt-labs";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-mzqUdT+dI7U0tHHcr0joIB1UCfKXrDdqhtVFShjIKus=";
  };

  nativeBuildInputs = [
    pythonRelaxDepsHook
  ];

  pythonRelaxDeps = [
    "agate"
  ];

  propagatedBuildInputs = [
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
