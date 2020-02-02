{ lib
, buildPythonPackage
, fetchPypi
, isPy27
, pytest
, locket
, numpy
, pandas
, pyzmq
, toolz
}:

buildPythonPackage rec {
  pname = "partd";
  version = "1.1.0";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "6e258bf0810701407ad1410d63d1a15cfd7b773fd9efe555dac6bb82cc8832b0";
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
