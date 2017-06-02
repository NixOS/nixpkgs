{ lib
, buildPythonPackage
, fetchPypi
, pytest
, cloudpickle
, numpy
, toolz
, dill
, pandas
, partd
}:

buildPythonPackage rec {
  pname = "dask";
  version = "0.14.3";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "9bf007f9cedc08f73089f0621ff65ec0882fc0a834acef56830dfd2872908211";
  };

  checkInputs = [ pytest ];
  propagatedBuildInputs = [ cloudpickle  numpy toolz dill pandas partd ];

  checkPhase = ''
    py.test dask
  '';

  # URLError
  doCheck = false;

  meta = {
    description = "Minimal task scheduling abstraction";
    homepage = "http://github.com/ContinuumIO/dask/";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fridh ];
  };
}
