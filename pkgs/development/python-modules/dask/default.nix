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
  version = "2.9.1";

  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "eec200032922b2249f7f1061f8701eaf3e68488cfa78ff2b47c3262f442bede7";
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
