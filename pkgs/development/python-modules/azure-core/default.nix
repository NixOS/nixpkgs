{ lib, stdenv, buildPythonPackage, fetchpatch, fetchPypi, pythonOlder
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
  version = "1.24.0";
  pname = "azure-core";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "sha256-NFsbBB+q19AgWyDVaX8dDfNEMC56qoUBkFWA/4e9C+U=";
  };

  patches = [
    # FIXME: fixes tests with new versions of flask/werkzeug
    # upstream PR: https://github.com/Azure/azure-sdk-for-python/pull/24450
    (fetchpatch {
      url = "https://github.com/Azure/azure-sdk-for-python/commit/fb20b0b985f614bb7bcd84f3f5f6f3105de25fd9.patch";
      stripLen = 3;
      sha256 = "sha256-Gt5T/UkQT1yml8bqYbeUpimfOPlmzpN1KKKUnbU9xJw=";
    })
  ];

  propagatedBuildInputs = [
    requests
    six
    typing-extensions
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

    "tests/test_rest_polling.py"
    "tests/async_tests/test_rest_polling_async.py"
  ];

  meta = with lib; {
    description = "Microsoft Azure Core Library for Python";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = licenses.mit;
    maintainers = with maintainers; [ jonringer ];
  };
}
