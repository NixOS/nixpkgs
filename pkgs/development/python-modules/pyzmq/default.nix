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
  version = "22.0.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f7f63ce127980d40f3e6a5fdb87abf17ce1a7c2bd8bf2c7560e1bbce8ab1f92d";
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
