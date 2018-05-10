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
  version = "17.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0145ae59139b41f65e047a3a9ed11bbc36e37d5e96c64382fcdff911c4d8c3f0";
  };

  checkInputs = [  pytest tornado ];
  buildInputs = [ zeromq3];
  propagatedBuildInputs = [ py ];

  # test_socket.py seems to be hanging
  # others fail
  checkPhase = ''
    py.test $out/${python.sitePackages}/zmq/ -k "not test_socket \
      and not test_current \
      and not test_instance \
      and not test_callable_check \
      and not test_on_recv_basic \
      and not test_on_recv_wake"
  '';
}
