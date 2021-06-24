{ buildPythonPackage
, fetchPypi
, pytestCheckHook
, tornado
, zeromq
, py
, python
}:

buildPythonPackage rec {
  pname = "pyzmq";
  version = "20.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "824ad5888331aadeac772bce27e1c2fbcab82fade92edbd234542c4e12f0dca9";
  };

  checkInputs = [
    pytestCheckHook
    tornado
  ];
  buildInputs = [ zeromq ];
  propagatedBuildInputs = [ py ];

  # failing tests
  disabledTests = [
    "test_socket" # hangs
    "test_current"
    "test_instance"
    "test_callable_check"
    "test_on_recv_basic"
    "test_on_recv_wake"
    "test_monitor" # https://github.com/zeromq/pyzmq/issues/1272
    "test_cython"
    "test_asyncio" # hangs
    "test_mockable" # fails
  ];

  pytestFlagsArray = [
    "$out/${python.sitePackages}/zmq/tests/" # Folder with tests
  ];

  # Some of the tests use localhost networking.
  __darwinAllowLocalNetworking = true;
}
