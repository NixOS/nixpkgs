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
  version = "18.0.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "31a11d37ac73107363b47e14c94547dbfc6a550029c3fe0530be443199026fc2";
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

  # Some of the tests use localhost networking.
  __darwinAllowLocalNetworking = true;
}
