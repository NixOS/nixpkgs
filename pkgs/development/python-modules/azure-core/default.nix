{ lib
, stdenv
, buildPythonPackage
, fetchPypi
, pythonOlder
, aiodns
, aiohttp
, flask
, mock
, pytest
, pytest-asyncio
, pytest-trio
, pytestCheckHook
, requests
, six
, trio
<<<<<<< HEAD
, typing-extensions
}:

buildPythonPackage rec {
  version = "1.28.0";
  pname = "azure-core";
  format = "setuptools";

  disabled = pythonOlder "3.7";
=======
, typing-extensions }:

buildPythonPackage rec {
  version = "1.26.3";
  pname = "azure-core";
  disabled = pythonOlder "3.6";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  __darwinAllowLocalNetworking = true;

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
<<<<<<< HEAD
    hash = "sha256-6e78Zvwf3lbatvBNTl0SxgdU1an6Sb3P2FNPyW7ZNr0=";
=======
    hash = "sha256-rL0NqpZ1zohiPaNcgNgZza+pFzHe5rJpXGTXyp2oLbQ=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    requests
    six
    typing-extensions
  ];

<<<<<<< HEAD
  passthru.optional-dependencies = {
    aio = [
      aiohttp
    ];
  };

  nativeCheckInputs = [
    aiodns
=======
  nativeCheckInputs = [
    aiodns
    aiohttp
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    flask
    mock
    pytest
    pytest-trio
    pytest-asyncio
    pytestCheckHook
    trio
<<<<<<< HEAD
  ] ++ lib.flatten (builtins.attrValues passthru.optional-dependencies);
=======
  ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  # test server needs to be available
  preCheck = ''
    export PYTHONPATH=tests/testserver_tests/coretestserver:$PYTHONPATH
  '';

<<<<<<< HEAD
  pytestFlagsArray = [
    "tests/"
  ];

=======
  pytestFlagsArray = [ "tests/" ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
  ] ++ lib.optionals stdenv.isDarwin [
    "location_polling_fail"
  ];
<<<<<<< HEAD

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  disabledTestPaths = [
    # requires testing modules which aren't published, and likely to create cyclic dependencies
    "tests/test_connection_string_parsing.py"
    # wants network
    "tests/async_tests/test_streaming_async.py"
    "tests/test_streaming.py"
    # testserver tests require being in a very specific working directory to make it work
    "tests/testserver_tests/"
    # requires missing pytest plugin
    "tests/async_tests/test_rest_asyncio_transport.py"
    # needs msrest, which cannot be included in nativeCheckInputs due to circular dependency new in msrest 0.7.1
    # azure-core needs msrest which needs azure-core
    "tests/test_polling.py"
    "tests/async_tests/test_base_polling_async.py"
    "tests/async_tests/test_polling_async.py"
  ];

  meta = with lib; {
    description = "Microsoft Azure Core Library for Python";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
<<<<<<< HEAD
    changelog = "https://github.com/Azure/azure-sdk-for-python/blob/main/sdk/core/azure-core/CHANGELOG.md";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.mit;
    maintainers = with maintainers; [ jonringer ];
  };
}
