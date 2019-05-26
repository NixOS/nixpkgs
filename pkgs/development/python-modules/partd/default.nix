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
  version = "0.3.10";

  src = fetchPypi {
    inherit pname version;
    sha256 = "33722a228ebcd1fa6f44b1631bdd4cff056376f89eb826d7d880b35b637bcfba";
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