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
  version = "0.7.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "5baf218713dc1ad4791f7bcf606ef8f618273945e788c59f9573aebd7cb851f8";
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
