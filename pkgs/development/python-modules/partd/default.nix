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
  version = "1.4.0";
  format = "setuptools";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-qg/zXbvMgHrjdNtWMy9MGzm0b2e/KXX1FR4LQYau0NU=";
  };

  nativeCheckInputs = [ pytest ];

  propagatedBuildInputs = [ locket numpy pandas pyzmq toolz ];

  checkPhase = ''
    rm partd/tests/test_zmq.py # requires network & fails
    py.test -k "not test_serialize"
  '';

  meta = {
    description = "Appendable key-value storage";
    license = with lib.licenses; [ bsd3 ];
    homepage = "https://github.com/dask/partd/";
  };
}
