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
  version = "0.15.2";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "abe6758540fdbc260f14ee71cebc3ab88682e24ff147afa89375b7006f57d3ed";
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
    homepage = http://github.com/ContinuumIO/dask/;
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fridh ];
  };
}
