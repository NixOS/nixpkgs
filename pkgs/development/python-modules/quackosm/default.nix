{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pdm-backend,
  poetry-core,

  beautifulsoup4,
  duckdb,
  geoarrow-pandas,
  geoarrow-pyarrow,
  geoarrow-rust-core,
  geopandas,
  h3,
  osmnx,
  polars,
  pooch,
  psutil,
  pyarrow-ops,
  pyarrow,
  geohash,
  requests,
  rich,
  shapely,
  tqdm,
  typeguard,

  pytest-parametrization,
  pytest-mock,
}:

buildPythonPackage rec {
  pname = "quackosm";
  version = "0.13.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "kraina-ai";
    repo = "quackosm";
    tag = version;
    hash = "sha256-Xm3VHK4dJQLTWmSadz/XnFHngLRJhANzYNPjs/pidZI=";
  };

  build-system = [
    poetry-core
    pdm-backend
  ];

  dependencies = [
    beautifulsoup4
    duckdb
    geoarrow-pandas
    geoarrow-pyarrow
    geoarrow-rust-core
    geopandas
    h3
    osmnx
    polars
    pooch
    psutil
    pyarrow-ops
    pyarrow
    geohash
    requests
    rich
    shapely
    tqdm
    typeguard
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-parametrization
    pytest-mock
  ];

  disabledTests = [
    # test requires internet
    "test_parquet_exception_wrapping"
    "test_uncovered_geometry_extract"
  ];

  preCheck =
    let
      disabled-test-paths = [
        # tests requires srai
        "tests/base/test_cli.py"
        "tests/base/test_intersection.py"
        "tests/base/test_osm_tags_filtering.py"
        "tests/base/test_pbf_file_reader.py"
        "tests/benchmark/test_big_file.py"

        # requires internet
        "tests/base/test_osm_extracts.py"
      ];
    in
    ''
      rm ${lib.concatStringsSep " " disabled-test-paths}

      export HOME=$(mktemp -d)
    '';

  pythonImportsCheck = [ "quackosm" ];

  meta = {
    description = "CLI tool for reading OpenStreetMap PBF files using DuckDB";
    homepage = "https://github.com/kraina-ai/quackosm";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sigmanificient ];
  };
}
