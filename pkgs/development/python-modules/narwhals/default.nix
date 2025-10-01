{
  lib,
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
  version = "2.6.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "narwhals-dev";
    repo = "narwhals";
    tag = "v${version}";
    hash = "sha256-peD5CLp5YCLPrOmXnoezT+gAJLf7zSb0xdhV+PhC/XI=";
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
  ++ lib.flatten (builtins.attrValues optional-dependencies);

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
