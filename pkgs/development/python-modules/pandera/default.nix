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
  pyarrow,
  pyarrow-hotfix,
  pyyaml,
  rich,
  scipy,
  shapely,
  typer,
  xarray,

  # tests
  duckdb,
  joblib,
  pytest-asyncio,
  pytestCheckHook,
  python-multipart,
  requests,
  uvicorn,
}:

buildPythonPackage (finalAttrs: {
  pname = "pandera";
  version = "0.33.1";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "unionai-oss";
    repo = "pandera";
    tag = "v${finalAttrs.version}";
    hash = "sha256-5sM/iEbv1+ojqwL/E9cVQxJW3u1dlzMQ6iAiKAjV+DI=";
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
        cli = [
          typer
          rich
          pyyaml
        ];
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
        pyarrow = [
          pyarrow
          narwhals
        ];
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
    pytest-asyncio
    pytestCheckHook
    python-multipart
    requests
    uvicorn
  ]
  ++ finalAttrs.passthru.optional-dependencies.all;

  disabledTestPaths = [
    "tests/pandas/test_docs_setting_column_widths.py" # tests doc generation, requires sphinx
    "tests/modin" # requires modin, not in nixpkgs
    "tests/pyspark" # requires pyspark[connect], which the nixpkgs pyspark does not provide
    # asserts on exact mypy diagnostics against upstream's pinned mypy 1.19
    "tests/mypy/"
    # narwhals backend is broken upstream: 33 failures across 7 files
    "tests/narwhals/"
    # passes, but adds ~4 min to the check phase
    "tests/strategies/test_strategies.py"
    # BackendNotFoundError: passes alone, but the *_narwhals_register tests
    # swap the backend registry process-wide and this runs after them
    "tests/strategies/test_no_filter_chain.py"
  ];

  disabledTests = [
    # ibis returns None where pandas returns NaN in the failure cases
    "test_ibis_custom_check"
    # ibis schemas still resolve to the ibis backend, not the narwhals one
    "test_ibis_backend_is_narwhals"
    # requires pyspark
    "test_pyspark_pandas_does_not_route_to_pyspark_sql"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # OOM error on ofborg:
    "test_engine_geometry_coerce_crs"
    # pandera.errors.SchemaError: Error while coercing 'geometry' to type geometry
    "test_schema_dtype_crs_with_coerce"
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
