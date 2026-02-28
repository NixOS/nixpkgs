{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonAtLeast,

  # build-system
  hatchling,

  # dependencies
  atpublic,
  parsy,
  python-dateutil,
  sqlglot,
  toolz,
  typing-extensions,
  tzdata,

  # tests
  pytestCheckHook,
  black,
  filelock,
  hypothesis,
  pytest-benchmark,
  pytest-httpserver,
  pytest-mock,
  pytest-randomly,
  pytest-snapshot,
  pytest-timeout,
  pytest-xdist,
  writableTmpDirAsHomeHook,

  # optional-dependencies
  # - athena
  pyathena,
  fsspec,
  # - bigquery
  db-dtypes,
  google-cloud-bigquery,
  google-cloud-bigquery-storage,
  pyarrow,
  pyarrow-hotfix,
  pydata-google-auth,
  numpy,
  pandas,
  rich,
  # - clickhouse
  clickhouse-connect,
  # - databricks
  # databricks-sql-connector-core, (unpackaged)
  # - datafusion
  datafusion,
  # - druid
  pydruid,
  # - duckdb
  duckdb,
  packaging,
  # - flink
  # - geospatial
  geopandas,
  shapely,
  # - mssql
  pyodbc,
  # - mysql
  pymysql,
  # - oracle
  oracledb,
  # - polars
  polars,
  # - postgres
  psycopg2,
  # - pyspark
  pyspark,
  # - snowflake
  snowflake-connector-python,
  # sqlite
  regex,
  # - trino
  trino-python-client,
  # - visualization
  graphviz,
  # examples
  pins,
}:
let
  testBackends = [
    "duckdb"
    "sqlite"
  ];

  ibisTestingData = fetchFromGitHub {
    owner = "ibis-project";
    repo = "testing-data";
    # https://github.com/ibis-project/ibis/blob/10.5.0/nix/overlay.nix#L94-L100
    rev = "b26bd40cf29004372319df620c4bbe41420bb6f8";
    hash = "sha256-1fenQNQB+Q0pbb0cbK2S/UIwZDE4PXXG15MH3aVbyLU=";
  };
in

buildPythonPackage (finalAttrs: {
  pname = "ibis-framework";
  version = "12.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ibis-project";
    repo = "ibis";
    tag = finalAttrs.version;
    hash = "sha256-GqSbjjUr4EaWueMl4TrhaDvqn1iDd4CO3QcDnOXfSAk=";
  };

  build-system = [
    hatchling
  ];

  dependencies = [
    atpublic
    parsy
    python-dateutil
    sqlglot
    toolz
    typing-extensions
    tzdata
  ];

  nativeCheckInputs = [
    pytestCheckHook
    black
    filelock
    hypothesis
    pytest-benchmark
    pytest-httpserver
    pytest-mock
    pytest-randomly
    pytest-snapshot
    pytest-timeout
    # this dependency is still needed due to use of strict markers and
    # `pytest.mark.xdist_group` in the ibis codebase
    pytest-xdist
    writableTmpDirAsHomeHook
  ]
  ++ lib.concatMap (name: finalAttrs.passthru.optional-dependencies.${name}) testBackends;

  pytestFlags = [
    "--benchmark-disable"
    "-Wignore::FutureWarning"
  ]
  ++ lib.optionals (pythonAtLeast "3.14") [
    # DeprecationWarning: '_UnionGenericAlias' is deprecated and slated for removal in Python 3.17
    "-Wignore::DeprecationWarning"
    # Multiple tests with warnings fail without it
    "-Wignore::pytest.PytestUnraisableExceptionWarning"
  ];

  enabledTestMarks = testBackends ++ [ "core" ];

  disabledTests = [
    # tries to download duckdb extensions
    "test_attach_sqlite"
    "test_connect_extensions"
    "test_load_extension"
    "test_read_csv_with_types"
    "test_read_sqlite"
    "test_register_sqlite"
    "test_roundtrip_xlsx"

    # AssertionError: value does not match the expected value in snapshot
    "test_union_aliasing"

    # requires network connection
    "test_s3_403_fallback"
    "test_hugging_face"

    # requires pytest 8.2+
    "test_roundtrip_delta"

    # AssertionError: value does not match the expected value in snapshot ibis/backends/tests/snapshots/test_sql/test_rewrite_context/sqlite/out.sql
    "test_rewrite_context"

    # Assertion error comparing a calculated version string with the actual (during nixpkgs-review)
    "test_builtin_scalar_noargs"

    # duckdb ParserError: syntax error at or near "AT"
    "test_90"

    # assert 0 == 3 (tests edge case behavior of databases)
    "test_self_join_with_generated_keys"

    # https://github.com/ibis-project/ibis/issues/11929
    # AssertionError: value does not match the expected value
    "ibasic_aggregation_with_join"
    "itest_endswith"
    "itest_multiple_limits"
    "itest_simple_joins"
    "test_aggregate_count_joined"
    "test_anti_join"
    "test_binop_parens"
    "test_bool_bool"
    "test_case_in_projection"
    "test_column_distinct"
    "test_column_expr_default_name"
    "test_column_expr_retains_name"
    "test_count_distinct"
    "test_difference_project_column"
    "test_fuse_projections"
    "test_having_from_filter"
    "test_intersect_project_column"
    "test_join_between_joins"
    "test_join_just_materialized"
    "test_limit_with_self_join"
    "test_lower_projection_sort_key"
    "test_multiple_count_distinct"
    "test_multiple_joins"
    "test_no_cart_join"
    "test_order_by_on_limit_yield_subquery"
    "test_parse_sql_aggregation_with_multiple_joins"
    "test_parse_sql_basic_aggregation"
    "test_parse_sql_basic_join[inner]"
    "test_parse_sql_basic_join[left]"
    "test_parse_sql_basic_join[right]"
    "test_parse_sql_basic_projection"
    "test_parse_sql_in_clause"
    "test_parse_sql_join_subquery"
    "test_parse_sql_join_with_filter"
    "test_parse_sql_limited_join"
    "test_parse_sql_multiple_joins"
    "test_parse_sql_scalar_subquery"
    "test_parse_sql_simple_reduction"
    "test_parse_sql_simple_select_count"
    "test_parse_sql_table_alias"
    "test_parse_sql_tpch"
    "test_sample"
    "test_select_sql"
    "test_selects_with_impure_operations_not_merged"
    "test_semi_join"
    "test_startswith"
    "test_subquery_in_union"
    "test_subquery_where_location"
    "test_table_difference"
    "test_table_distinct"
    "test_table_drop_with_filter"
    "test_table_intersect"
    "test_union_order_by"
    "test_union_project_column"
    "test_union"
    "test_where_analyze_scalar_op"
    "test_where_no_pushdown_possible"
    "test_where_simple_comparisons"
    "test_where_with_between"
    "test_where_with_join"
  ]
  ++ lib.optionals (pythonAtLeast "3.14") [
    # ExceptionGroup: multiple unraisable exception warnings (4 sub-exceptions)
    "test_non_roundtripable_str_type"
    "test_parse_dtype_roundtrip"

    # AssertionError: value does not match the expected value in snapshot ...
    "test_annotated_function_without_decoration"
    "test_error_message"
    "test_error_message_when_constructing_literal"
    "test_signature_from_callable_with_keyword_only_arguments"
  ];

  # patch out tests that check formatting with black
  postPatch = ''
    find ibis/tests -type f -name '*.py' -exec sed -i \
      -e '/^ *assert_decompile_roundtrip/d' \
      -e 's/^\( *\)code = ibis.decompile(expr, format=True)/\1code = ibis.decompile(expr)/g' {} +
  '';

  preCheck = ''
    export IBIS_TEST_DATA_DIRECTORY="ci/ibis-testing-data"

    # copy the test data to a directory
    ln -s "${ibisTestingData}" "$IBIS_TEST_DATA_DIRECTORY"
  '';

  postCheck = ''
    rm -r "$IBIS_TEST_DATA_DIRECTORY"
  '';

  pythonImportsCheck = [ "ibis" ] ++ map (backend: "ibis.backends.${backend}") testBackends;

  optional-dependencies = {
    athena = [
      pyathena
      pyarrow
      pyarrow-hotfix
      numpy
      pandas
      rich
      packaging
      fsspec
    ];
    bigquery = [
      db-dtypes
      google-cloud-bigquery
      google-cloud-bigquery-storage
      pyarrow
      pyarrow-hotfix
      pydata-google-auth
      numpy
      pandas
      rich
    ];
    clickhouse = [
      clickhouse-connect
      pyarrow
      pyarrow-hotfix
      numpy
      pandas
      rich
    ];
    databricks = [
      # databricks-sql-connector-core (unpackaged)
      pyarrow
      pyarrow-hotfix
      numpy
      pandas
      rich
    ];
    datafusion = [
      datafusion
      pyarrow
      pyarrow-hotfix
      numpy
      pandas
      rich
    ];
    druid = [
      pydruid
      pyarrow
      pyarrow-hotfix
      numpy
      pandas
      rich
    ];
    duckdb = [
      duckdb
      pyarrow
      pyarrow-hotfix
      numpy
      pandas
      rich
      packaging
    ];
    flink = [
      pyarrow
      pyarrow-hotfix
      numpy
      pandas
      rich
    ];
    geospatial = [
      geopandas
      shapely
    ];
    mssql = [
      pyodbc
      pyarrow
      pyarrow-hotfix
      numpy
      pandas
      rich
    ];
    mysql = [
      pymysql
      pyarrow
      pyarrow-hotfix
      numpy
      pandas
      rich
    ];
    oracle = [
      oracledb
      packaging
      pyarrow
      pyarrow-hotfix
      numpy
      pandas
      rich
    ];
    polars = [
      polars
      packaging
      pyarrow
      pyarrow-hotfix
      numpy
      pandas
      rich
    ];
    postgres = [
      psycopg2
      pyarrow
      pyarrow-hotfix
      numpy
      pandas
      rich
    ];
    pyspark = [
      pyspark
      packaging
      pyarrow
      pyarrow-hotfix
      numpy
      pandas
      rich
    ];
    snowflake = [
      snowflake-connector-python
      pyarrow
      pyarrow-hotfix
      numpy
      pandas
      rich
    ];
    sqlite = [
      regex
      pyarrow
      pyarrow-hotfix
      numpy
      pandas
      rich
    ];
    trino = [
      trino-python-client
      pyarrow
      pyarrow-hotfix
      numpy
      pandas
      rich
    ];
    visualization = [ graphviz ];
    decompiler = [ black ];
    examples = [ pins ] ++ pins.optional-dependencies.gcs;
  };

  meta = {
    description = "Productivity-centric Python Big Data Framework";
    homepage = "https://github.com/ibis-project/ibis";
    changelog = "https://github.com/ibis-project/ibis/blob/${finalAttrs.src.tag}/docs/release_notes.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      cpcloud
      sarahec
    ];
  };
})
