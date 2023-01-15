{ lib
, buildPythonPackage
, fetchPypi
, py
, pytestCheckHook
, python
, pythonOlder
, tornado
, zeromq
}:

buildPythonPackage rec {
  pname = "pyzmq";
  version = "24.0.1";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-IW9dfbtnFmdZ5ZsEebyoK4rPm+1gFbUmuOsQFD+wjnc=";
  };

  buildInputs = [
    zeromq
  ];

  propagatedBuildInputs = [
    py
  ];

  checkInputs = [
    pytestCheckHook
    tornado
  ];

  pythonImportsCheck = [
    "zmq"
  ];

  pytestFlagsArray = [
    "$out/${python.sitePackages}/zmq/tests/" # Folder with tests
  ];

  disabledTests = [
    # Tests hang
    "test_socket"
    "test_monitor"
    # https://github.com/zeromq/pyzmq/issues/1272
    "test_cython"
    # Test fails
    "test_mockable"
    # Issues with the sandbox
    "TestFutureSocket"
    "TestIOLoop"
    "TestPubLog"
  ];

  # Some of the tests use localhost networking.
  __darwinAllowLocalNetworking = true;

  meta = with lib; {
    description = "Python bindings for ØMQ";
    homepage = "https://pyzmq.readthedocs.io/";
    license = with licenses; [ bsd3 /* or */ lgpl3Only ];
    maintainers = with maintainers; [ ];
  };
}
