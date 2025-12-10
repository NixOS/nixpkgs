{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pythonOlder,
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
  version = "3.7.2";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "pyproj4";
    repo = "pyproj";
    tag = version;
    hash = "sha256-WV344gxcmq08sIUVevn6uD50FSy4JvLt4aret5ZakYQ=";
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
    # https://github.com/pyproj4/pyproj/issues/1553
    "test_datum_horizontal"
    "test_sub_crs"
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

  meta = with lib; {
    description = "Python interface to PROJ library";
    mainProgram = "pyproj";
    homepage = "https://github.com/pyproj4/pyproj";
    changelog = "https://github.com/pyproj4/pyproj/blob/${src.rev}/docs/history.rst";
    license = licenses.mit;
    maintainers = with maintainers; [
      dotlambda
    ];
    teams = [ teams.geospatial ];
  };
}
