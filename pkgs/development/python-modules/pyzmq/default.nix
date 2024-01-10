{ lib
, buildPythonPackage
, fetchPypi
, py
, pytestCheckHook
, python
, pythonOlder
, tornado
, zeromq
, pytest-asyncio
}:

buildPythonPackage rec {
  pname = "pyzmq";
  version = "25.1.1";
  format = "setuptools";

  disabled = pythonOlder "3.6";

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
    pytestCheckHook
    tornado
    pytest-asyncio
  ];

  pythonImportsCheck = [
    "zmq"
  ];

  pytestFlagsArray = [
    "$out/${python.sitePackages}/zmq/tests/" # Folder with tests
    # pytest.ini is missing in pypi's sdist
    # https://github.com/zeromq/pyzmq/issues/1853#issuecomment-1592731986
    "--asyncio-mode auto"
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
