{
  lib,
  aiomysql,
  aiopg,
  aiosqlite,
  asyncpg,
  buildPythonPackage,
  cryptography,
  databases,
  fastapi,
  fetchFromGitHub,
  httpx,
  importlib-metadata,
  mysqlclient,
  nest-asyncio,
  orjson,
  poetry-core,
  psycopg2,
  pydantic,
  pymysql,
  pytest-asyncio,
  pytestCheckHook,
  pythonOlder,
  sqlalchemy,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "ormar";
  version = "0.20.1";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "collerek";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-DzvmJpWJANIoc5lvWAD0b2bhbKdDEpNL2l3TqXSZSnc=";
  };

  pythonRelaxDeps = [
    "databases"
    "pydantic"
    "SQLAlchemy"
  ];

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs =
    [
      databases
      psycopg2
      pydantic
      sqlalchemy
      psycopg2
    ]
    ++ lib.optionals (pythonOlder "3.8") [
      typing-extensions
      importlib-metadata
    ];

  passthru.optional-dependencies = {
    postgresql = [ asyncpg ];
    postgres = [ asyncpg ];
    aiopg = [ aiopg ];
    mysql = [ aiomysql ];
    sqlite = [ aiosqlite ];
    orjson = [ orjson ];
    crypto = [ cryptography ];
    all = [
      aiomysql
      aiopg
      aiosqlite
      asyncpg
      cryptography
      mysqlclient
      orjson
      pymysql
    ];
  };

  nativeCheckInputs = [ pytestCheckHook ];

  checkInputs = [
    fastapi
    httpx
    nest-asyncio
    pytest-asyncio
  ] ++ passthru.optional-dependencies.all;

  disabledTestPaths = [ "benchmarks/test_benchmark_*.py" ];

  disabledTests = [
    # TypeError: Object of type bytes is not JSON serializable
    "test_bulk_operations_with_json"
    "test_all_endpoints"
    # Tests require a database
    "test_model_multiple_instances_of_same_table_in_schema"
    "test_load_all_multiple_instances_of_same_table_in_schema"
    "test_filter_groups_with_instances_of_same_table_in_schema"
    "test_model_multiple_instances_of_same_table_in_schema"
    "test_right_tables_join"
    "test_multiple_reverse_related_objects"
    "test_related_with_defaults"
    "test_model_creation"
    "test_default_orders_is_applied_on_related_two_fields"
    "test_default_orders_is_applied_from_relation"
    "test_sum_method"
    "test_count_method "
    "test_queryset_methods"
    "test_queryset_update"
    "test_selecting_subset"
    "test_selecting_subset_of_through_model"
    "test_simple_queryset_values"
    "test_queryset_values_nested_relation"
    "test_queryset_simple_values_list"
    "test_queryset_nested_relation_values_list"
    "test_queryset_nested_relation_subset_of_fields_values_list"
    "test_m2m_values"
    "test_nested_m2m"
    "test_nested_flatten_and_exception"
    "test_queryset_values_multiple_select_related"
    "test_querysetproxy_values"
    "test_querysetproxy_values_list"
    "test_reverse_many_to_many_cascade"
    "test_not_saved_raises_error"
    "test_not_existing_raises_error"
    "test_assigning_related_objects"
    "test_quering_of_the_m2m_models"
    "test_removal_of_the_relations"
    "test_selecting_related"
    "test_adding_unsaved_related"
    "test_removing_unsaved_related"
    "test_quering_of_related_model_works_but_no_result"
  ];

  pythonImportsCheck = [ "ormar" ];

  meta = with lib; {
    description = "Async ORM with fastapi in mind and pydantic validation";
    homepage = "https://github.com/collerek/ormar";
    changelog = "https://github.com/collerek/ormar/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ andreasfelix ];
  };
}
