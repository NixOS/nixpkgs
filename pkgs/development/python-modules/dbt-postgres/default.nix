{
  lib,
  agate,
  buildPythonPackage,
  fetchFromGitHub,
  dbt-adapters,
  dbt-common,
  dbt-core,
  hatchling,
  psycopg2,
  pyprojectVersionPatchHook,
  pytestCheckHook,
  pytest-dotenv,
  pytest-mock,
  pytest-xdist,
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
  ];

  enabledTestPaths = [
    "tests/unit" # other tests require running postgres
  ];

  pythonImportsCheck = [ "dbt.adapters.postgres" ];

  meta = {
    description = "Plugin enabling dbt to work with a Postgres database";
    homepage = "https://github.com/dbt-labs/dbt-adapters/tree/main/dbt-postgres";
    changelog = "https://github.com/dbt-labs/dbt-adapters/blob/main/dbt-postgres/CHANGELOG.md";
    license = lib.licenses.asl20;
  };
}
