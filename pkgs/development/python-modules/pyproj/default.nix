{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  replaceVars,

  certifi,
  cython,
  numpy,
  pandas,
  proj,
  setuptools,
  shapely,
  xarray,
}:

buildPythonPackage rec {
  pname = "pyproj";
  version = "3.8.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pyproj4";
    repo = "pyproj";
    tag = version;
    hash = "sha256-+2wUMbswg2yltNMLPc9U8MbEFx2xKVWxGjP/TBfCjto=";
  };

  # force pyproj to use ${proj}
  patches = [
    (replaceVars ./001.proj.patch {
      proj = proj;
      projdev = proj.dev;
    })
  ];

  build-system = [
    cython
    setuptools
  ];

  buildInputs = [ proj ];

  dependencies = [ certifi ];

  nativeCheckInputs = [
    numpy
    pandas
    pytestCheckHook
    shapely
    xarray
  ];

  preCheck = ''
    # import from $out
    rm -r pyproj
  '';

  disabledTestPaths = [
    "test/test_datadir.py"
  ];

  disabledTests = [
    # The following tests try to access network and end up with a URLError
    "test__load_grid_geojson_old_file"
    "test_get_transform_grid_list"
    "test_sync__area_of_use__list"
    "test_sync__bbox__list"
    "test_sync__download_grids"
    "test_sync__file__list"
    "test_sync__source_id__list"
    "test_sync_download"
    "test_transformer_group__download_grids"
    # https://github.com/pyproj4/pyproj/issues/1588
    "test_coordinate_operation__from_string"
    "test_transformer_from_pipeline__input_types"
    "test_transformer_from_pipeline__wkt_json"
  ];

  pythonImportsCheck = [
    "pyproj"
    "pyproj.crs"
    "pyproj.transformer"
    "pyproj.geod"
    "pyproj.proj"
    "pyproj.database"
    "pyproj.list"
    "pyproj.datadir"
    "pyproj.network"
    "pyproj.sync"
    "pyproj.enums"
    "pyproj.aoi"
    "pyproj.exceptions"
  ];

  meta = {
    description = "Python interface to PROJ library";
    mainProgram = "pyproj";
    homepage = "https://github.com/pyproj4/pyproj";
    changelog = "https://github.com/pyproj4/pyproj/blob/${src.rev}/docs/history.rst";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      dotlambda
    ];
    teams = [ lib.teams.geospatial ];
  };
}
