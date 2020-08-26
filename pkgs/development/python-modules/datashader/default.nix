{ lib
, buildPythonPackage
, fetchPypi
, dask
, distributed
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
, pyyaml
, requests
, scikitimage
, scipy
, pytest
, pytest-benchmark
, flake8
, nbsmoke
, fastparquet
, testpath
, nbconvert
, pytest_xdist
}:

buildPythonPackage rec {
  pname = "datashader";
  version = "0.11.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "05p81aff7x70yj8llclclgz6klvfzqixwxfng6awn3y5scv18w40";
  };

  propagatedBuildInputs = [
    dask
    distributed
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
    pyyaml
    requests
    scikitimage
    scipy
    testpath
  ];

  checkInputs = [
    pytest
    pytest-benchmark
    pytest_xdist # not needed
    flake8
    nbsmoke
    fastparquet
    pandas
    nbconvert
  ];

  postConfigure = ''
    substituteInPlace setup.py \
      --replace "'numba >=0.37.0,<0.49'" "'numba'"
  '';

  checkPhase = ''
    pytest -n $NIX_BUILD_CORES datashader
  '';

  meta = with lib; {
    description = "Data visualization toolchain based on aggregating into a grid";
    homepage = "https://datashader.org";
    license = licenses.bsd3;
    maintainers = [ maintainers.costrouc ];
  };
}
