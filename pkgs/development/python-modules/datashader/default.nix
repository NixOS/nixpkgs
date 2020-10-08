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
  version = "0.11.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b1f80415f72f92ccb660aaea7b2881ddd35d07254f7c44101709d42e819d6be6";
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

  # dask doesn't do well with large core counts
  checkPhase = ''
    pytest -n $NIX_BUILD_CORES datashader -k 'not dask.array'
  '';

  meta = with lib; {
    description = "Data visualization toolchain based on aggregating into a grid";
    homepage = "https://datashader.org";
    license = licenses.bsd3;
    maintainers = [ maintainers.costrouc ];
  };
}
