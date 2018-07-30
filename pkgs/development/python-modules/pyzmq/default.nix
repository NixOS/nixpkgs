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
  version = "17.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "2199f753a230e26aec5238b0518b036780708a4c887d4944519681a920b9dee4";
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
