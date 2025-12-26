{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,
  setuptools-scm,

  # dependencies
  numpy,
  packaging,
  pandas,
  pydantic,
  typeguard,
  typing-extensions,
  typing-inspect,

  # optional-dependencies
  black,
  dask,
  duckdb,
  fastapi,
  geopandas,
  hypothesis,
  ibis-framework,
  pandas-stubs,
  polars,
  pyyaml,
  scipy,
  shapely,

  # tests
  joblib,
  pyarrow-hotfix,
  pyarrow,
  pytest-asyncio,
  pytestCheckHook,
  pythonAtLeast,
  rich,
}:

buildPythonPackage rec {
  pname = "pandera";
  version = "0.27.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "unionai-oss";
    repo = "pandera";
    tag = "v${version}";
    hash = "sha256-r9lHK2fK1q2pHhpdW+Q83Kk+OZhAOwx8k3GgxHHlj/4=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  env.SETUPTOOLS_SCM_PRETEND_VERSION = version;

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
          #frictionless # not in nixpkgs
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
          duckdb
        ];
        pandas = [
          numpy
          pandas
        ];
        polars = [ polars ];
      };
    in
    extras // { all = lib.concatLists (lib.attrValues extras); };

  nativeCheckInputs = [
    joblib
    pyarrow
    pyarrow-hotfix
    pytest-asyncio
    pytestCheckHook
    rich
  ]
  ++ optional-dependencies.all;

  disabledTestPaths = [
    "tests/fastapi/test_app.py" # tries to access network
    "tests/pandas/test_docs_setting_column_widths.py" # tests doc generation, requires sphinx
    "tests/modin" # requires modin, not in nixpkgs
    "tests/mypy/test_pandas_static_type_checking.py" # some typing failures
    "tests/pyspark" # requires spark

    # KeyError: 'dask'
    "tests/dask/test_dask.py::test_series_schema"
    "tests/dask/test_dask_accessor.py::test_dataframe_series_add_schema"

    # TypeError: memtable() got an unexpected keyword argument 'name'
    # https://github.com/unionai-oss/pandera/issues/2154
    "tests/ibis/test_ibis_container.py"
  ];

  disabledTests = [
    # TypeError: __class__ assignment: 'GeoDataFrame' object...
    "test_schema_model"
    "test_schema_from_dataframe"
    "test_schema_no_geometry"
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
    changelog = "https://github.com/unionai-oss/pandera/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ bcdarwin ];
  };
}
