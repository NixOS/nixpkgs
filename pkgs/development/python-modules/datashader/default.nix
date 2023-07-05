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
  version = "0.15.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-gbBIGnVTDnE8+s9CHaXgYspXkYMkZph/cLWXJMwDhy8=";
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
    maintainers = with maintainers; [ costrouc ];
  };
}
