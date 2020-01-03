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
  version = "1.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "54fd91bc3b9c38159c790cd16950dbca6b019a2ead4c51dee4f9efc884f8ce0e";
  };

  checkInputs = [ pytest ];

  propagatedBuildInputs = [ locket numpy pandas pyzmq toolz ];

  checkPhase = ''
    rm partd/tests/test_zmq.py # requires network & fails
    py.test -k "not test_serialize"
  '';

  meta = {
    description = "Appendable key-value storage";
    license = with lib.licenses; [ bsd3 ];
    homepage = https://github.com/dask/partd/;
  };
}