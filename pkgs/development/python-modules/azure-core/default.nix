{ lib, stdenv, buildPythonPackage, fetchPypi, isPy27
, aiodns
, aiohttp
, flask
, mock
, msrest
, pytest
, pytest-asyncio
, pytest-trio
, pytestCheckHook
, requests
, six
, trio
, typing-extensions
}:

buildPythonPackage rec {
  version = "1.23.1";
  pname = "azure-core";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "sha256-KKAd+68KaBLE4qgtFkLqMJVqlznyW8d8myO5H06mjw8=";
  };

  propagatedBuildInputs = [
    requests
    six
  ];

  checkInputs = [
    aiodns
    aiohttp
    flask
    mock
    msrest
    pytest
    pytest-trio
    pytest-asyncio
    pytestCheckHook
    trio
    typing-extensions
  ];

  # test server needs to be available
  preCheck = ''
    export PYTHONPATH=tests/testserver_tests/coretestserver:$PYTHONPATH
  '';

  pytestFlagsArray = [ "tests/" ];
  # disable tests which touch network
  disabledTests = [
    "aiohttp"
    "multipart_send"
    "response"
    "request"
    "timeout"
    "test_sync_transport_short_read_download_stream"
    "test_aio_transport_short_read_download_stream"
  # disable 8 tests failing on some darwin machines with errors:
  # azure.core.polling.base_polling.BadStatus: Invalid return status 403 for 'GET' operation
  # azure.core.exceptions.HttpResponseError: Operation returned an invalid status 'Forbidden'
  ] ++ lib.optional stdenv.isDarwin [
    "location_polling_fail"
  ];
  disabledTestPaths = [
    # requires testing modules which aren't published, and likely to create cyclic dependencies
    "tests/test_connection_string_parsing.py"
    # wants network
    "tests/async_tests/test_streaming_async.py"
    "tests/test_streaming.py"
    # testserver tests require being in a very specific working directory to make it work
    "tests/testserver_tests/"
  ];

  meta = with lib; {
    description = "Microsoft Azure Core Library for Python";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = licenses.mit;
    maintainers = with maintainers; [ jonringer ];
  };
}
