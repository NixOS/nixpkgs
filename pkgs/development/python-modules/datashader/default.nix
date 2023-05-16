{ lib
, buildPythonPackage
, fetchPypi
, dask
, bokeh
, toolz
, datashape
, numba
, numpy
, pandas
, pillow
, xarray
, colorcet
, param
, pyct
, scipy
, pytestCheckHook
, pythonOlder
, nbsmoke
, fastparquet
, nbconvert
, pytest-xdist
, netcdf4
}:

buildPythonPackage rec {
  pname = "datashader";
<<<<<<< HEAD
  version = "0.15.2";
=======
  version = "0.14.4";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-lTlSk3kofWnBDpq04LKQDhoWAE1v8G3g2EqmLEgzsbs=";
=======
    hash = "sha256-AkHmEflRvjJFlycI5adpuxg6+/zu7Dzy7vbYCvd1b70=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    dask
    bokeh
    toolz
    datashape
    numba
    numpy
    pandas
    pillow
    xarray
    colorcet
    param
    pyct
    scipy
  ] ++ dask.optional-dependencies.complete;

  nativeCheckInputs = [
    pytestCheckHook
    pytest-xdist
    nbsmoke
    fastparquet
    nbconvert
    netcdf4
  ];

  # The complete extra is for usage with conda, which we
  # don't care about
  postPatch = ''
    substituteInPlace setup.py \
      --replace "dask[complete]" "dask" \
      --replace "xarray >=0.9.6" "xarray"
  '';

  preCheck = ''
    export HOME=$TMPDIR
  '';

  pytestFlagsArray = [
    "datashader"
  ];

  disabledTests = [
    # Not compatible with current version of bokeh
    # see: https://github.com/holoviz/datashader/issues/1031
    "test_interactive_image_update"
    # Latest dask broken array marshalling
    # see: https://github.com/holoviz/datashader/issues/1032
    "test_raster_quadmesh_autorange_reversed"
  ];

  disabledTestPaths = [
    # 31/50 tests fail with TypeErrors
    "datashader/tests/test_datatypes.py"
  ];

  pythonImportsCheck = [
    "datashader"
  ];

  meta = with lib;{
    description = "Data visualization toolchain based on aggregating into a grid";
    homepage = "https://datashader.org";
    license = licenses.bsd3;
<<<<<<< HEAD
    maintainers = with maintainers; [ ];
=======
    maintainers = with maintainers; [ costrouc ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
