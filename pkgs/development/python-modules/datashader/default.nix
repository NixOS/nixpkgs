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
, nbsmoke
, fastparquet
, nbconvert
, pytest-xdist
, netcdf4
}:

buildPythonPackage rec {
  pname = "datashader";
  version = "0.13.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-6JscHm1QjDmXOLLa83qhAvY/xwvlPM6duQ1lSxnCVV8=";
  };

  # the complete extra is for usage with conda, which we
  # don't care about
  postPatch = ''
    substituteInPlace setup.py \
      --replace "dask[complete]" "dask"
  '';

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
  ];

  checkInputs = [
    pytestCheckHook
    pytest-xdist # not needed
    nbsmoke
    fastparquet
    nbconvert
    netcdf4
  ];

  preCheck = ''
    export HOME=$TMPDIR
  '';

  pytestFlagsArray = [
    "-n $NIX_BUILD_CORES"
    "datashader"
  ];

  disabledTests = [
    # not compatible with current version of bokeh
    # see: https://github.com/holoviz/datashader/issues/1031
    "test_interactive_image_update"
    # latest dask broken array marshalling
    # see: https://github.com/holoviz/datashader/issues/1032
    "test_raster_quadmesh_autorange_reversed"
  ];

  disabledTestPaths = [
    # 31/50 tests fail with TypeErrors
    "datashader/tests/test_datatypes.py"
  ];

  meta = with lib;{
    description = "Data visualization toolchain based on aggregating into a grid";
    homepage = "https://datashader.org";
    license = licenses.bsd3;
    maintainers = [ maintainers.costrouc ];
  };
}
