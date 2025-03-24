{
  lib,
  buildPythonPackage,
  dbt-core,
  fetchFromGitHub,
  pytestCheckHook,
  setuptools,
  snowflake-connector-python,
}:

buildPythonPackage rec {
  pname = "dbt-snowflake";
  version = "1.9.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "dbt-labs";
    repo = "dbt-snowflake";
    tag = "v${version}";
    hash = "sha256-oPzSdAQgb2fKES3YcSGYjILFqixxxjdLCNVytVPecTg=";
  };

  build-system = [ setuptools ];

  dependencies = [
    dbt-core
    snowflake-connector-python
  ] ++ snowflake-connector-python.optional-dependencies.secure-local-storage;

  nativeCheckInputs = [ pytestCheckHook ];

  pytestFlagsArray = [ "tests/unit" ];

  pythonImportsCheck = [ "dbt.adapters.snowflake" ];

  meta = {
    description = "Plugin enabling dbt to work with Snowflake";
    homepage = "https://github.com/dbt-labs/dbt-snowflake";
    changelog = "https://github.com/dbt-labs/dbt-snowflake/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ tjni ];
  };
}
