{ lib, buildPythonPackage, fetchPypi, isPy27
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
  version = "1.17.0";
  pname = "azure-core";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "25407390dde142d3e41ecf78bb18cedda9b7f7a0af558d082dec711c4a334f46";
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
  disabledTests = [ "aiohttp" "multipart_send" "response" "request" "timeout" ];
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
