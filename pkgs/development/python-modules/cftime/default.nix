{ buildPythonPackage
, fetchPypi
, pytest
, coveralls
, pytestcov
, cython
, numpy
}:

buildPythonPackage rec {
  pname = "cftime";
  version = "1.2.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ab5d5076f7d3e699758a244ada7c66da96bae36e22b9e351ce0ececc36f0a57f";
  };

  checkInputs = [ pytest coveralls pytestcov ];
  buildInputs = [ cython ];
  requiredPythonModules = [ numpy ];

  checkPhase = ''
    py.test
  '';

  meta = {
    description = "Time-handling functionality from netcdf4-python";
  };

}
