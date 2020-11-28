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
  version = "1.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8d6a1144f43b9d7a180d7ceb3aa8015b7133c615fbac231bed184a91129f0207";
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
