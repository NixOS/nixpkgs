{ lib
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
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
  version = "3.4.1";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "pyproj4";
    repo = "pyproj";
    rev = "refs/tags/${version}";
    hash = "sha256-SbuamcVXvbV5eGm08jhbp1yBno60vkniHrH5xrPej2A=";
  };

  # force pyproj to use ${proj}
  patches = [
    (substituteAll {
      src = ./001.proj.patch;
      proj = proj;
      projdev = proj.dev;
    })
    # update tests for PROJ 9.2
    (fetchpatch {
      url = "https://github.com/pyproj4/pyproj/commit/59d16f57387bbd09b4d61ab95ac520cfec103af1.patch";
      hash = "sha256-pSDkb+c02KNNlGPwBN/9TQdVJorLr2xvvFB92h84OsQ=";
    })
    (fetchpatch {
      url = "https://github.com/pyproj4/pyproj/commit/dd06b3fee4eaafe80da3414560107ecdda42f5e0.patch";
      hash = "sha256-6CFVdtovfGqWGXq4auX2DtY7sT4Y0amTJ7phjq5emYM=";
    })
    (fetchpatch {
      url = "https://github.com/pyproj4/pyproj/commit/9283f962e4792da2a7f05ba3735c1ed7f3479502.patch";
      hash = "sha256-GVYXOAQBHL5WkAF7OczHyGxo7vq8LmT7I/R1jUPCxi4=";
    })
    (fetchpatch {
      url = "https://github.com/pyproj4/pyproj/commit/9dfbb2465296cc8f0de2ff1d68a9b65f7cef52e1.patch";
      hash = "sha256-F+qS9JZF0JjqyapFhEhIcZ/WHJyfI3jiMC8K7uTpWUA=";
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

  meta = {
    description = "Python interface to PROJ library";
    homepage = "https://github.com/pyproj4/pyproj";
    changelog = "https://github.com/pyproj4/pyproj/blob/${src.rev}/docs/history.rst";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ lsix dotlambda ];
  };
}
