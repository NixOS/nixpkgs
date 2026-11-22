{
  lib,
  agate,
  buildPythonPackage,
  fetchFromGitHub,
  dbt-adapters,
  dbt-common,
  dbt-core,
  dbt-tests-adapter,
  hatchling,
  psycopg2,
  pyprojectVersionPatchHook,
  pytestCheckHook,
  pytest-dotenv,
  pytest-mock,
  pytest-xdist,
  postgresql,
  postgresqlTestHook,
}:

buildPythonPackage rec {
  pname = "dbt-postgres";
  version = "1.11.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "dbt-labs";
    repo = "dbt-adapters";
    # Check https://pypi.org/project/dbt-postgres/#history for version to revision mapping
    rev = "a375bd590133e6756952c82ea0652c3e62a6562a";
    hash = "sha256-7UoJnWwrjFXNMyssbdzG4bWgsRz2ajQsZhfYSuZjyNE=";
  };

  sourceRoot = "${src.name}/dbt-postgres";

  build-system = [ hatchling ];

  nativeBuildInputs = [
    pyprojectVersionPatchHook
  ];

  pythonRemoveDeps = [ "psycopg2-binary" ];

  dependencies = [
    agate
    dbt-adapters
    dbt-common
    dbt-core
    psycopg2
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-dotenv
    pytest-mock
    pytest-xdist
    dbt-tests-adapter
    postgresql
    postgresqlTestHook
  ];

  postgresqlEnableTCP = true;
  postgresqlTestSetupCommands = ''
    cat ./scripts/setup_test_database.sql | PGUSER=postgres psql postgres
  '';

  enabledTestPaths = [
    "tests/unit"
    # selection of integration tests (full test suite takes hours)
    "tests/functional/basic"
    "tests/functional/compile"
    "tests/functional/statements"
    "tests/functional/postgres"
  ];

  disabledTestPaths = [
    # duplicate file name
    "tests/functional/materializations/materialized_view_tests/test_materialized_view.py"
  ];

  disabledTests = [
    # require network connection
    "test_deps_fail"
    "test_deps"
    "test_working_macros"
    # fail due to test configuration issues
    "test_ok"
    "test_seed_empty_creates_table_with_zero_rows"
    "test_seed_empty_preserves_column_types"
    "test_build_empty_with_seed"
    "test_seed_grants"
    "test_incremental_grants"
  ];

  env = {
    "DBT_TEST_USER_1" = "dbt_test_user_1";
    "DBT_TEST_USER_2" = "dbt_test_user_2";
    "DBT_TEST_USER_3" = "dbt_test_user_3";
  };

  pytestFlags = [ "--exitfirst" ];

  # parallel tests interfere with each other
  preInstallCheck = ''
    export NIX_BUILD_CORES=1
  '';

  pythonImportsCheck = [ "dbt.adapters.postgres" ];

  meta = {
    description = "Plugin enabling dbt to work with a Postgres database";
    homepage = "https://github.com/dbt-labs/dbt-adapters/tree/main/dbt-postgres";
    changelog = "https://github.com/dbt-labs/dbt-adapters/blob/main/dbt-postgres/CHANGELOG.md";
    license = lib.licenses.asl20;
  };
}
