{ lib
, buildPythonPackage
, fetchPypi
, pytest
, locket
, numpy
, pandas
, pyzmq
, toolz
}:

buildPythonPackage rec {
  pname = "partd";
  version = "0.3.9";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1fd6d9c12f14ea180e659a9e4a686ff2816dd930e8fb0b84c0d8116a29cfe66b";
  };

  checkInputs = [ pytest ];

  propagatedBuildInputs = [ locket numpy pandas pyzmq toolz ];

  checkPhase = ''
    rm partd/tests/test_zmq.py # requires network & fails
    py.test
  '';

  meta = {
    description = "Appendable key-value storage";
    license = with lib.licenses; [ bsd3 ];
    homepage = https://github.com/dask/partd/;
  };
}