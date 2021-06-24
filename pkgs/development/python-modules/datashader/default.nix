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
  version = "0.12.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a135612876dc3e4b16ccb9ddb70de50519825c8c1be251b49aefa550bcf8a39a";
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
