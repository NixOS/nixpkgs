{
  lib,
  buildPythonPackage,
  dbt-core,
  fetchFromGitHub,
  pytestCheckHook,
  pythonOlder,
  setuptools,
  snowflake-connector-python,
}:

buildPythonPackage rec {
  pname = "dbt-snowflake";
  version = "1.8.3";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "dbt-labs";
    repo = "dbt-snowflake";
    rev = "refs/tags/v${version}";
    hash = "sha256-jvhjf+Ce/oyHXFxMryz5Uy6Hq5Sx6vKgaGEJVAzqSdA=";
  };

  build-system = [ setuptools ];

  dependencies = [
    dbt-core
    snowflake-connector-python
  ] ++ snowflake-connector-python.optional-dependencies.secure-local-storage;

  nativeCheckInputs = [ pytestCheckHook ];

  pytestFlagsArray = [ "tests/unit" ];

  pythonImportsCheck = [ "dbt.adapters.snowflake" ];

  meta = with lib; {
    description = "Plugin enabling dbt to work with Snowflake";
    homepage = "https://github.com/dbt-labs/dbt-snowflake";
    changelog = "https://github.com/dbt-labs/dbt-snowflake/blob/${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ tjni ];
  };
}
