{ lib
, bokeh
, buildPythonPackage
, fetchPypi
, fsspec
, pytest
, pythonOlder
, cloudpickle
, numpy
, toolz
, dill
, pandas
, partd
}:

buildPythonPackage rec {
  pname = "dask";
  version = "2.6.0";

  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "81c7891f0d2e7ac03d1f7fabf1f639360a1db52c03a7155ba9b08e9ee6280f2b";
  };

  checkInputs = [ pytest ];
  propagatedBuildInputs = [
    bokeh cloudpickle dill fsspec numpy pandas partd toolz ];

  checkPhase = ''
    py.test dask
  '';

  # URLError
  doCheck = false;

  meta = {
    description = "Minimal task scheduling abstraction";
    homepage = https://github.com/ContinuumIO/dask/;
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fridh ];
  };
}
