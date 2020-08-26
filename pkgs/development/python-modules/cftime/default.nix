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
  version = "1.1.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1w2iakkzxfhyrqrspn40am8x7bzdp5qqdqbm1asbj7fa3mivi17x";
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