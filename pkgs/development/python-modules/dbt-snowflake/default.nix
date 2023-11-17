{ lib
, buildPythonPackage
, fetchFromGitHub
, dbt-core
, pytestCheckHook
, snowflake-connector-python
}:

buildPythonPackage rec {
  pname = "dbt-snowflake";
  version = "1.6.2";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "dbt-labs";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-AOO3VbU1R3/snH7U7K9XXokBGXtf9Udpv7eR5HCBxss=";
  };

  propagatedBuildInputs = [
    dbt-core
    snowflake-connector-python
  ] ++ snowflake-connector-python.optional-dependencies.secure-local-storage;

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pytestFlagsArray = [
    "tests/unit"
  ];

  pythonImportsCheck = [
    "dbt.adapters.snowflake"
  ];

  meta = with lib; {
    description = "Plugin enabling dbt to work with Snowflake";
    homepage = "https://github.com/dbt-labs/dbt-snowflake";
    changelog = "https://github.com/dbt-labs/dbt-snowflake/blob/${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ tjni ];
  };
}
