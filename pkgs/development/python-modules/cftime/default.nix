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
  version = "1.0.2.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1fxpvy3z0b3ga8ylr54ml7nxsfah2bh5azk43nb565rcka3x909c";
  };

  checkInputs = [ pytest coveralls pytestcov ];
  buildInputs = [ cython ];
  propagatedBuildInputs = [ numpy ];

  checkPhase = ''
    py.test
  '';

  meta = {
    description = "Time-handling functionality from netcdf4-python";
  };

}