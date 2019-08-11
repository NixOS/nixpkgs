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
  version = "2.2.0";

  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0wkiqkckwy7fv6m86cs3m3g6jdikkkw84ki9hiwp60xpk5xngnf0";
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
