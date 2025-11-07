{
  lib,
  aiohttp,
  aioresponses,
  buildPythonPackage,
  dateparser,
  fetchFromGitHub,
  pycryptodome,
  pytest-asyncio,
  pytestCheckHook,
  pythonOlder,
  requests-mock,
  requests,
  six,
  ujson,
  setuptools,
  websockets,
}:

buildPythonPackage rec {
  pname = "python-binance";
  version = "1.0.29";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "sammchardy";
    repo = "python-binance";
    tag = "v${version}";
    hash = "sha256-Hqd6228k2j1BPzBBCRpdEp0rAGxZt00XPnzpCPlwIfg=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    dateparser
    requests
    pycryptodome
    six
    ujson
    websockets
  ];

  nativeCheckInputs = [
    aioresponses
    pytest-asyncio
    pytestCheckHook
    requests-mock
  ];

  disabledTestPaths = [
    # Tests require network access
    "tests/test_api_request.py"
    "tests/test_async_client.py"
    "tests/test_async_client_futures.py"
    "tests/test_async_client_margin.py"
    "tests/test_async_client_options.py"
    "tests/test_async_client_portfolio.py"
    "tests/test_async_client_ws_api.py"
    "tests/test_async_client_ws_futures_requests.py"
    "tests/test_client.py"
    "tests/test_client_futures.py"
    "tests/test_client_gift_card.py"
    "tests/test_client_margin.py"
    "tests/test_client_options.py"
    "tests/test_client_portfolio.py"
    "tests/test_client_ws_api.py"
    "tests/test_client_ws_futures_requests.py"
    "tests/test_depth_cache.py"
    "tests/test_get_order_book.py"
    "tests/test_ping.py"
    "tests/test_reconnecting_websocket.py"
    "tests/test_socket_manager.py"
    "tests/test_streams.py"
    "tests/test_threaded_socket_manager.py"
    "tests/test_threaded_stream.py"
    "tests/test_ws_api.py"
  ];

  pythonImportsCheck = [ "binance" ];

  meta = with lib; {
    description = "Binance Exchange API python implementation for automated trading";
    homepage = "https://github.com/sammchardy/python-binance";
    license = licenses.mit;
    maintainers = with maintainers; [ bhipple ];
  };
}
