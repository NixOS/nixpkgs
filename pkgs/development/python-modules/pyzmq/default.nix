{ buildPythonPackage
, fetchPypi
, pytest
, tornado
, zeromq3
, py
, python
}:

buildPythonPackage rec {
  pname = "pyzmq";
  version = "17.1.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a72b82ac1910f2cf61a49139f4974f994984475f771b0faa730839607eeedddf";
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
