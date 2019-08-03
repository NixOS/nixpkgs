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
  version = "1.2.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "5e7876bae2a01b355d1969b73aeafa23310febd8c353163910b73e93dc7e492c";
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
