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
  version = "1.1.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "2e70135d6856805699b52774d8e0cec41beda92bdfc9f9c776962b4bfb34822c";
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
