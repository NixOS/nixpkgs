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
  version = "1.0.3.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0362dhxbzk593walyjz30dll6y2y79wialik647cbwdsf3ad0x6x";
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