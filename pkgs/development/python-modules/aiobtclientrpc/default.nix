{
  lib,
  async-timeout,
  buildPythonPackage,
  fetchFromCodeberg,
  httpx-socks,
  httpx,
  proxy-py,
  pytest-asyncio,
  pytest-cov-stub,
  pytest-mock,
  pytestCheckHook,
  python-socks,
  rencode,
  setuptools,
  tiny-proxy,
}:

buildPythonPackage (finalAttrs: {
  pname = "aiobtclientrpc";
  version = "6.0.1";
  pyproject = true;

  src = fetchFromCodeberg {
    owner = "plotski";
    repo = "aiobtclientrpc";
    tag = "v${finalAttrs.version}";
    hash = "sha256-4FWfzt+A9BY4nnaQU3xwdDFhuOMtfBFHYNoHaEOy7+0=";
  };

  pythonRelaxDeps = [ "async-timeout" ];

  build-system = [ setuptools ];

  dependencies = [
    async-timeout
    httpx
    httpx-socks
    python-socks
    rencode
  ];

  nativeCheckInputs = [
    proxy-py
    pytest-asyncio
    pytest-cov-stub
    pytest-mock
    pytestCheckHook
    tiny-proxy
  ];

  disabledTests = [
    # Missing lambda parameter
    "test_add_event_handler_with_autoremove"
    # Try to use `htpasswd` and `nginx` with hard-coded paths
    "test_authentication_error[rtorrent_http]"
    "test_api_as_context_manager[rtorrent_http]"
    "test_add_and_remove_torrents[rtorrent_http-paused]"
    "test_add_and_remove_torrents[rtorrent_http-started]"
    "test_proxy[rtorrent_http-http_proxy]"
    "test_timeout[rtorrent_http]"
    "test_event_subscriptions_survive_reconnecting[rtorrent_http]"
    "test_waiting_for_event[rtorrent_http]"
    "test_proxy[rtorrent_http-socks4_proxy]"
    "test_proxy[rtorrent_http-socks5_proxy]"
    # Tests are outdated
    "test_DelugeRPCRequest_equality"
  ];

  pythonImportsCheck = [ "aiobtclientrpc" ];

  meta = {
    description = "Asynchronous low-level communication with BitTorrent clients";
    homepage = "https://aiobtclientrpc.readthedocs.io";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ ambroisie ];
  };
})
