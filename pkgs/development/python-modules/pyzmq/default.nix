{ lib
, buildPythonPackage
, fetchPypi
, pytest
, tornado
, zeromq3
, py
, python
}:

buildPythonPackage rec {
  pname = "pyzmq";
  version = "16.0.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0322543fff5ab6f87d11a8a099c4c07dd8a1719040084b6ce9162bcdf5c45c9d";
  };

  checkInputs = [  pytest tornado ];
  buildInputs = [ zeromq3];
  propagatedBuildInputs = [ py ];

  # Disable broken test
  # https://github.com/zeromq/pyzmq/issues/799
  checkPhase = ''
    py.test $out/${python.sitePackages}/zmq/ -k "not test_large_send and not test_recv_json_cancelled"
  '';
}
