{ lib
, buildPythonPackage
, fetchFromGitHub
, python
, proj
, pythonOlder
, substituteAll
, cython
, pytestCheckHook
, mock
, certifi
, numpy
, shapely
, pandas
, xarray
}:

buildPythonPackage rec {
  pname = "pyproj";
  version = "3.6.1";
  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "pyproj4";
    repo = "pyproj";
    rev = "refs/tags/${version}";
    hash = "sha256-ynAhu89VpvtQJRkIeVyffQHhd+OvWSiZzaI/7nd6fXA=";
  };

  # force pyproj to use ${proj}
  patches = [
    (substituteAll {
      src = ./001.proj.patch;
      proj = proj;
      projdev = proj.dev;
    })
  ];

  nativeBuildInputs = [ cython ];
  buildInputs = [ proj ];

  propagatedBuildInputs = [
     certifi
  ];

  nativeCheckInputs = [
    pytestCheckHook
    mock
    numpy
    shapely
    pandas
    xarray
  ];

  preCheck = ''
    # import from $out
    rm -r pyproj
  '';

  disabledTestPaths = [
    "test/test_doctest_wrapper.py"
    "test/test_datadir.py"
  ];

  disabledTests = [
    # The following tests try to access network and end up with a URLError
    "test__load_grid_geojson_old_file"
    "test_get_transform_grid_list"
    "test_get_transform_grid_list__area_of_use"
    "test_get_transform_grid_list__bbox__antimeridian"
    "test_get_transform_grid_list__bbox__out_of_bounds"
    "test_get_transform_grid_list__contains"
    "test_get_transform_grid_list__file"
    "test_get_transform_grid_list__source_id"
    "test_sync__area_of_use__list"
    "test_sync__bbox__list"
    "test_sync__bbox__list__exclude_world_coverage"
    "test_sync__download_grids"
    "test_sync__file__list"
    "test_sync__source_id__list"
    "test_sync_download"
    "test_sync_download__directory"
    "test_sync_download__system_directory"
    "test_transformer_group__download_grids"
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
    homepage = "https://github.com/pyproj4/pyproj";
    changelog = "https://github.com/pyproj4/pyproj/blob/${src.rev}/docs/history.rst";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ lsix dotlambda ];
  };
}
