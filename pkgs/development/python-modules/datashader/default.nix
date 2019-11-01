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
  version = "0.8.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "59ac9e3830167d07b350992402a9f547f26eca45cd69a0fb04061a4047e7ff2a";
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
