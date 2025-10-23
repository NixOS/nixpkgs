{
  lib,
  aiosqlite,
  asyncpg,
  black,
  buildPythonPackage,
  colorama,
  email-validator,
  fetchFromGitHub,
  httpx,
  inflection,
  jinja2,
  orjson,
  postgresql,
  postgresqlTestHook,
  pydantic,
  pytestCheckHook,
  python-dateutil,
  setuptools,
  targ,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "piccolo";
  version = "1.29.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "piccolo-orm";
    repo = "piccolo";
    tag = version;
    hash = "sha256-CVN3aT1Xa7qKztEh1+jP9mlIu7Nw4EbjRYxzthycd4k=";
  };

  build-system = [ setuptools ];

  dependencies = [
    black
    colorama
    inflection
    jinja2
    pydantic
    targ
    typing-extensions
  ];

  optional-dependencies = {
    orjson = [ orjson ];
    postgres = [ asyncpg ];
    sqlite = [ aiosqlite ];
  };

  nativeCheckInputs = [
    email-validator
    httpx
    postgresql
    postgresqlTestHook
    pytestCheckHook
    python-dateutil
  ]
  ++ lib.flatten (builtins.attrValues optional-dependencies);

  pythonImportsCheck = [ "piccolo" ];

  disabledTests = [
    # Timing issues
    "TestMigrations"
    "TestForwardsBackwards"
    "TestMigrationManager"
    "TestTableStorage"
    "TestGraph"
    "TestDumpLoad"
    "test_add_column"
    "test_altering_table_in_schema"
    "test_auto_all"
    "test_auto"
    "test_clean"
    "test_column_name_correct"
    "test_create_table"
    "test_get_table_classes"
    "test_integer_to_bigint"
    "test_integer_to_varchar"
    "test_lazy_reference_to_app"
    "test_lazy_table_reference"
    "test_new"
    "test_on_conflict"
    "test_psql"
    "test_run"
    "test_set_digits"
    "test_set_length"
    "test_set_null"
    "test_shared"
    "test_show_all"
    "test_warn_if_are_conflicting_objects"
    "test_warn_if_is_conflicting"
  ];

  meta = {
    description = "ORM and query builder which supports asyncio";
    homepage = "https://github.com/piccolo-orm/piccolo";
    changelog = "https://github.com/piccolo-orm/piccolo/blob/${src.tag}/CHANGES.rst";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
