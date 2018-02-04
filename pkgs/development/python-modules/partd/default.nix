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
  version = "0.3.8";

  src = fetchPypi {
    inherit pname version;
    sha256 = "67291f1c4827cde3e0148b3be5d69af64b6d6169feb9ba88f0a6cfe77089400f";
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