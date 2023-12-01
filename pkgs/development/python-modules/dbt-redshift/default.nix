{ lib
, buildPythonPackage
, fetchFromGitHub
, agate
, boto3
, dbt-core
, dbt-postgres
, pytestCheckHook
, pythonRelaxDepsHook
, redshift-connector
}:

buildPythonPackage rec {
  pname = "dbt-redshift";
  version = "1.6.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "dbt-labs";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-5sgge55BwvC00Gj3UvLS/uzCgNSi4j4YdVlg/LuJI+s=";
  };

  nativeBuildInputs = [
    pythonRelaxDepsHook
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
