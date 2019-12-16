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
  version = "2.9.0";

  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1w1hqr8vyx6ygwflj2737dcy0mmgvrc0s602gnny8pzlcbs9m76b";
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
