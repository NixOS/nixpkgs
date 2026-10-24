{
  lib,
  stdenv,
  buildPythonPackage,
  dask,
  duckdb,
  fetchFromGitHub,
  uv-build,
  hypothesis,
  ibis-framework,
  packaging,
  pandas,
  polars,
  pyarrow-hotfix,
  pyarrow,
  pyspark,
  pytest-env,
  pytest-xdist,
  pytestCheckHook,
  rich,
  sqlframe,
}:

buildPythonPackage (finalAttrs: {
  pname = "narwhals";
  version = "2.27.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "narwhals-dev";
    repo = "narwhals";
    tag = "v${finalAttrs.version}";
    hash = "sha256-9YBjXLG7YwwsWgExwfRN4VNVfZjYQLgw1ZIZAuEgmBs=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "uv_build>=0.11.0,<0.13.0" "uv_build"
  '';

  build-system = [ uv-build ];

  optional-dependencies = {
    # cudf = [ cudf ];
    dask = [ dask ] ++ dask.optional-dependencies.dataframe;
    # modin = [ modin ];
    pandas = [ pandas ];
    polars = [ polars ];
    pyarrow = [ pyarrow ];
    pyspark = [ pyspark ];
    ibis = [
      ibis-framework
      rich
      packaging
      pyarrow-hotfix
    ];
    sqlframe = [ sqlframe ];
  };

  nativeCheckInputs = [
    duckdb
    hypothesis
    pytest-env
    pytest-xdist
    pytestCheckHook
  ]
  ++ lib.flatten (builtins.attrValues finalAttrs.passthru.optional-dependencies);

  pythonImportsCheck = [ "narwhals" ];

  disabledTests = [
    # Flaky
    "test_rolling_var_hypothesis"
    # Missing file
    "test_pyspark_connect_deps_2517"
    # Timezone issue
    "test_to_datetime"
    "test_unary_two_elements"
    # Test requires pyspark binary
    "test_datetime_w_tz_pyspark"
    "test_convert_time_zone_to_connection_tz_pyspark"
    "test_replace_time_zone_to_connection_tz_pyspark"
    "test_lazy"
    # DuckDB 1.4.x compatibility - empty result schema handling with PyArrow
    "test_skew_expr"
    # sqlframe improvements cause strict XPASS failures (tests expected to fail now pass)
    "test_unique_expr"
    # sqlframe issues
    "test_over_quantile"
    "test_quantile_expr"
    "test_join_duplicate_column_names"
    # PySpark does not yet fully support pandas >= 3.0.0
    "test_backend_version[pyspark[connect]]"
    # Polars issues
    "test_length_changing_operand_is_not_scalar"
    "test_contains_chunked"
  ];

  disabledTestPaths = lib.optionals (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isx86_64) [
    # Segfault in included polars/lazyframe
    "tests/tpch_q1_test.py"
  ];

  pytestFlags = [
    "-Wignore::DeprecationWarning"
  ];

  meta = {
    description = "Lightweight and extensible compatibility layer between dataframe libraries";
    homepage = "https://github.com/narwhals-dev/narwhals";
    changelog = "https://github.com/narwhals-dev/narwhals/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
