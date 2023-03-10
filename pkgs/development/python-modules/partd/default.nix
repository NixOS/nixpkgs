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
  version = "1.3.0";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-zpGrzcYXjWaLyqQxeRpakX2QI0HLGT9UP+RF1JRmBIU=";
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
