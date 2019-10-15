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
  version = "2.5.2";

  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "21a228d6f7d1506cd032161670483dd1f119820a9be879a95aebb284b425c843";
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
