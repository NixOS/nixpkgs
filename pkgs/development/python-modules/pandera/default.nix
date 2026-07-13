{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,
  setuptools-scm,

  # dependencies
  packaging,
  pandas,
  pydantic,
  typeguard,
  typing-extensions,
  typing-inspect,

  # optional-dependencies
  black,
  dask,
  fastapi,
  frictionless,
  geopandas,
  hypothesis,
  ibis-framework,
  narwhals,
  numpy,
  pandas-stubs,
  polars,
  pyyaml,
  scipy,
  shapely,
  xarray,

  # tests
  duckdb,
  joblib,
  pyarrow-hotfix,
  pyarrow,
  pytest-asyncio,
  pytestCheckHook,
  pythonAtLeast,
  rich,
}:

buildPythonPackage (finalAttrs: {
  pname = "pandera";
  version = "0.32.1";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "unionai-oss";
    repo = "pandera";
    tag = "v${finalAttrs.version}";
    hash = "sha256-6xLrLPFjU3BMw/G8T4O48S8Ntx8EN29OQvSv2pCjIJg=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    packaging
    pydantic
    typeguard
    typing-extensions
    typing-inspect
  ];

  optional-dependencies =
    let
      dask-dataframe = [ dask ] ++ dask.optional-dependencies.dataframe;
      extras = {
        strategies = [ hypothesis ];
        hypotheses = [ scipy ];
        io = [
          pyyaml
          black
          frictionless
        ];
        # pyspark expression does not define optional-dependencies.connect:
        #pyspark = [ pyspark ] ++ pyspark.optional-dependencies.connect;
        # modin not in nixpkgs:
        #modin = [
        #  modin
        #  ray
        #] ++ dask-dataframe;
        #modin-ray = [
        #  modin
        #  ray
        #];
        #modin-dask = [
        #  modin
        #] ++ dask-dataframe;
        dask = dask-dataframe;
        mypy = [ pandas-stubs ];
        fastapi = [ fastapi ];
        geopandas = [
          geopandas
          shapely
        ];
        ibis = [
          ibis-framework
          pyarrow-hotfix
        ];
        narwhals = [ narwhals ];
        pandas = [
          numpy
          pandas
        ];
        polars = [ polars ];
        xarray = [
          numpy
          xarray
        ];
      };
    in
    extras // { all = lib.concatLists (lib.attrValues extras); };

  nativeCheckInputs = [
    duckdb
    joblib
    pyarrow
    pyarrow-hotfix
    pytest-asyncio
    pytestCheckHook
    rich
  ]
  ++ finalAttrs.passthru.optional-dependencies.all;

  disabledTestPaths = [
    "tests/fastapi/test_app.py" # tries to access network
    "tests/pandas/test_docs_setting_column_widths.py" # tests doc generation, requires sphinx
    "tests/modin" # requires modin, not in nixpkgs
    "tests/mypy/test_pandas_static_type_checking.py" # some typing failures
    "tests/pyspark" # requires pyspark, not in nixpkgs

    # KeyError: 'dask'
    "tests/dask/test_dask.py::test_series_schema"
    "tests/dask/test_dask_accessor.py::test_dataframe_series_add_schema"
    # mypy tests
    "tests/mypy/"
    # Very time-consuming tests
    "tests/strategies/test_strategies.py"
    # Narwhals backend issues
    "tests/narwhals/"
    # Schema issues
    "tests/strategies/test_no_filter_chain.py"
  ];

  disabledTests = [
    # AssertionError: assert failure_cases.equals(expected_failure_cases)
    "test_ibis_custom_check"

    # TypeError: __class__ assignment: 'GeoDataFrame' object...
    "test_schema_model"
    "test_schema_from_dataframe"
    "test_schema_no_geometry"
    # Tests requires pyspark
    "test_pyspark_pandas_does_not_route_to_pyspark_sql"
    # Assertion error due to None vs. NaN
    "test_ibis_backend_is_narwhals"
    "test_ibis_custom_check"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # OOM error on ofborg:
    "test_engine_geometry_coerce_crs"
    # pandera.errors.SchemaError: Error while coercing 'geometry' to type geometry
    "test_schema_dtype_crs_with_coerce"
  ]
  ++ lib.optionals (pythonAtLeast "3.13") [
    # AssertionError: assert DataType(Sparse[float64, nan]) == DataType(Sparse[float64, nan])
    "test_legacy_default_pandas_extension_dtype"
  ];

  pythonImportsCheck = [
    "pandera"
    "pandera.api"
    "pandera.config"
    "pandera.dtypes"
    "pandera.engines"
  ];

  meta = {
    description = "Light-weight, flexible, and expressive statistical data testing library";
    homepage = "https://pandera.readthedocs.io";
    changelog = "https://github.com/unionai-oss/pandera/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ bcdarwin ];
  };
})
