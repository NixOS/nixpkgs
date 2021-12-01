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
  version = "22.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8eddc033e716f8c91c6a2112f0a8ebc5e00532b4a6ae1eb0ccc48e027f9c671c";
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
