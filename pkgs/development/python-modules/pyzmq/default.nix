{ buildPythonPackage
, fetchPypi
, pytest
, tornado
, zeromq
, py
, python
}:

buildPythonPackage rec {
  pname = "pyzmq";
  version = "17.1.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "83722236bd6ae6a07dec0cb728906785040e91826c7575709a258b4e21d0f812";
  };

  checkInputs = [  pytest tornado ];
  buildInputs = [ zeromq ];
  propagatedBuildInputs = [ py ];

  # test_socket.py seems to be hanging
  # others fail
  # for test_monitor: https://github.com/zeromq/pyzmq/issues/1272
  checkPhase = ''
    py.test $out/${python.sitePackages}/zmq/ -k "not test_socket \
      and not test_current \
      and not test_instance \
      and not test_callable_check \
      and not test_on_recv_basic \
      and not test_on_recv_wake \
      and not test_monitor"
  '';
}
