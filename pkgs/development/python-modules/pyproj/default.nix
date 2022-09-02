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
  version = "3.3.1";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "pyproj4";
    repo = "pyproj";
    rev = "refs/tags/${version}";
    hash = "sha256-QmpwnOnMjV29Tq+M6FCotDytq6zlhsp0Zgzw3V7nhNQ=";
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

  checkInputs = [
    pytestCheckHook
    mock
    numpy
    shapely
    pandas
    xarray
  ];

  preCheck = ''
    # We need to build extensions locally to run tests
    ${python.interpreter} setup.py build_ext --inplace
    cd test
  '';

  disabledTestPaths = [
    "test_doctest_wrapper.py"
    "test_datadir.py"
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

  meta = {
    description = "Python interface to PROJ.4 library";
    homepage = "https://github.com/pyproj4/pyproj";
    license = with lib.licenses; [ isc ];
    maintainers = with lib.maintainers; [ lsix ];
  };
}
