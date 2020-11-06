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
  version = "19.0.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "296540a065c8c21b26d63e3cea2d1d57902373b16e4256afe46422691903a438";
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
