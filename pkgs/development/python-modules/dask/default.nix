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
  version = "0.20.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d4139a03ab5eb6cedeb06cf1e39af90fb5226ca214d77408def7677d7e6b7af3";
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
    homepage = https://github.com/ContinuumIO/dask/;
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fridh ];
  };
}
