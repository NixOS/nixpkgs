{
  stdenv,
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  multimethod,
  numpy,
  packaging,
  pandas,
  pydantic,
  typeguard,
  typing-inspect,
  wrapt,
  # test
  joblib,
  pyarrow,
  pytestCheckHook,
  pytest-asyncio,
  # optional dependencies
  black,
  dask,
  fastapi,
  geopandas,
  hypothesis,
  pandas-stubs,
  polars,
  pyyaml,
  scipy,
  shapely,
}:

buildPythonPackage rec {
  pname = "pandera";
  version = "0.22.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "unionai-oss";
    repo = "pandera";
    tag = "v${version}";
    hash = "sha256-QOks3L/ZebkoWXWbHMn/tV9SmYSbR+gZ8wpqWoydkPM=";
  };

  build-system = [ setuptools ];

  dependencies = [
    multimethod
    numpy
    packaging
    pandas
    pydantic
    typeguard
    typing-inspect
    wrapt
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
        polars = [ polars ];
      };
    in
    extras // { all = lib.concatLists (lib.attrValues extras); };

  nativeCheckInputs = [
    pytestCheckHook
    pytest-asyncio
    joblib
    pyarrow
  ] ++ optional-dependencies.all;

  disabledTestPaths = [
    "tests/fastapi/test_app.py" # tries to access network
    "tests/core/test_docs_setting_column_widths.py" # tests doc generation, requires sphinx
    "tests/modin" # requires modin, not in nixpkgs
    "tests/mypy/test_static_type_checking.py" # some typing failures
    "tests/pyspark" # requires spark
  ];

  disabledTests = lib.optionals stdenv.hostPlatform.isDarwin [
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
    changelog = "https://github.com/unionai-oss/pandera/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ bcdarwin ];
  };
}
