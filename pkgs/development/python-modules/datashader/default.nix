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

  pytestFlagsArray = [
    "-n $NIX_BUILD_CORES"
    "datashader"
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
