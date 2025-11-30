{
  lib,
  stdenv,
  buildPythonPackage,
  dask,
  duckdb,
  fetchFromGitHub,
  hatchling,
  hypothesis,
  ibis-framework,
  packaging,
  pandas,
  polars,
  pyarrow-hotfix,
  pyarrow,
  pyspark,
  pytest-env,
  pytestCheckHook,
  rich,
  sqlframe,
}:

buildPythonPackage rec {
  pname = "narwhals";
  version = "2.10.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "narwhals-dev";
    repo = "narwhals";
    tag = "v${version}";
    hash = "sha256-a/X6LVzFxtjyaFcgZapJZ5i9h5LSB39XjGu/HdhPf8k=";
  };

  build-system = [ hatchling ];

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
    pytestCheckHook
  ]
  ++ lib.concatAttrValues optional-dependencies;

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
    # Incompatible with ibis 11
    "test_unique_3069"
    # DuckDB 1.4.x compatibility - empty result schema handling with PyArrow
    "test_skew_expr"
    # ibis improvements cause strict XPASS failures (tests expected to fail now pass)
    "test_empty_scalar_reduction_with_columns"
    "test_collect_empty"
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
    changelog = "https://github.com/narwhals-dev/narwhals/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
