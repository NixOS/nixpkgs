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
}:

buildPythonPackage rec {
  pname = "datashader";
  version = "0.9.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "3a423d61014ae8d2668848edab6c12a6244be6f249570bd7811dd5698d5ff633";
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
    flake8
    nbsmoke
    fastparquet
    pandas
    nbconvert
  ];

  postConfigure = ''
    substituteInPlace setup.py \
      --replace "'testpath<0.4'" "'testpath'"
  '';

  checkPhase = ''
    pytest datashader
  '';

  meta = with lib; {
    description = "Data visualization toolchain based on aggregating into a grid";
    homepage = https://datashader.org;
    license = licenses.bsd3;
    maintainers = [ maintainers.costrouc ];
  };
}
