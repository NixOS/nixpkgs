{ lib
, buildPythonPackage
, fetchPypi
, fetchpatch
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
  patches = [ (fetchpatch {
    # Unpins pyct==0.46 (Sep. 11, 2020).
    # Will be incorporated into the next datashader release after 0.11.1
    url = "https://github.com/holoviz/datashader/pull/960/commits/d7a462fa399106c34fd0d44505a8a73789dbf874.patch";
    sha256 = "1wqsk9dpxnkxr49fa7y5q6ahin80cvys05lnirs2w2p1dja35y4x";
  })];

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
