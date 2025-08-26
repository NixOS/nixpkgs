{
  lib,
  buildPythonPackage,
  dbt-core,
  fetchPypi,
  pytestCheckHook,
  hatchling,
  snowflake-connector-python,
}:

buildPythonPackage rec {
  pname = "dbt-snowflake";
  version = "1.10.0";
  pyproject = true;

  # missing tags on GitHub
  src = fetchPypi {
    pname = "dbt_snowflake";
    inherit version;
    hash = "sha256-Y5H7ATm8bntl4YaF5l9DZiRhHt2q2/XaICp+PR9ywIw=";
  };

  pythonRelaxDeps = [
    "certifi"
  ];

  build-system = [ hatchling ];

  dependencies = [
    dbt-core
    snowflake-connector-python
  ]
  ++ snowflake-connector-python.optional-dependencies.secure-local-storage;

  nativeCheckInputs = [ pytestCheckHook ];

  enabledTestPaths = [ "tests/unit" ];

  pytestFlagsArray = [
    # pyproject.toml specifies -n auto which only pytest-xdist understands
    "--override-ini addopts=''"
  ];

  pythonImportsCheck = [ "dbt.adapters.snowflake" ];

  meta = {
    description = "Plugin enabling dbt to work with Snowflake";
    homepage = "https://github.com/dbt-labs/dbt-adapters/blob/main/dbt-snowflake";
    changelog = "https://github.com/dbt-labs/dbt-adapters/blob/main/dbt-snowflake/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ tjni ];
  };
}
