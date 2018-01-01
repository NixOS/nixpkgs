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
  version = "0.3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "066d254d2dh9xcanffgkjgwxpz5v0059b063bij10fvzl2y49hzx";
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