{ lib
, buildPythonPackage
, fetchFromGitHub
, python
, proj
, pythonOlder
, substituteAll
, cython
, pytestCheckXfailHook
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
    pytestCheckXfailHook
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
    # Runs shell command 'sync' which requires network
    "test_sync__area_of_use__list"
    "test_sync__bbox__list"
    "test_sync__bbox__list__exclude_world_coverage"
    "test_sync__file__list"
    "test_sync__source_id__list"
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
