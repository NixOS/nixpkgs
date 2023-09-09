{ lib
, buildPythonPackage
, fetchPypi
, py
, pytest-asyncio
, pytestCheckHook
, python
, pythonOlder
, tornado
, zeromq
}:

buildPythonPackage rec {
  pname = "pyzmq";
  version = "25.1.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-JZwiSFtxq6zfqL95cgzXvPS50SizDqVU8BrnH9v9qiM=";
  };

  buildInputs = [
    zeromq
  ];

  propagatedBuildInputs = [
    py
  ];

  nativeCheckInputs = [
    pytest-asyncio
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
    "test_callable_check"
    "test_on_recv_wake"
    "test_deny"
    "test_allow"
    "test_on_recv_basic"
    "test_on_recv_async"
    "TestThreadAuthentication"
    "TestAsyncioAuthentication"
    "TestFutureSocket"
    "TestIOLoop"
    "TestPubLog"
  ];

  # Some of the tests use localhost networking.
  __darwinAllowLocalNetworking = true;

  meta = with lib; {
    description = "Python bindings for ØMQ";
    homepage = "https://pyzmq.readthedocs.io/";
    changelog = "https://github.com/zeromq/pyzmq/blob/v${version}/docs/source/changelog.md";
    license = with licenses; [ bsd3 /* or */ lgpl3Only ];
    maintainers = with maintainers; [ ];
  };
}
