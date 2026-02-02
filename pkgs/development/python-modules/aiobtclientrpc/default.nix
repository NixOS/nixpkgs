{
  lib,
  buildPythonPackage,
  fetchFromCodeberg,
  async-timeout,
  httpx,
  httpx-socks,
  proxy-py,
  pytest-asyncio,
  pytest-mock,
  pytestCheckHook,
  python-socks,
  rencode,
  setuptools,
  fetchpatch,
}:

buildPythonPackage (finalAttrs: {
  pname = "aiobtclientrpc";
  version = "5.0.1";
  pyproject = true;

  src = fetchFromCodeberg {
    owner = "plotski";
    repo = "aiobtclientrpc";
    tag = "v${finalAttrs.version}";
    hash = "sha256-2nBrIMlYUI4PwirkiSJSkw5zw2Kc/KoVRyIIYYx4iYs=";
  };

  patches = [
    # compatibility with python3.14: fix retrival of non-running event loop
    (fetchpatch {
      url = "https://codeberg.org/plotski/aiobtclientrpc/commit/1328e281d28f17c9b2c092539b4ab7402f1082b3.patch";
      hash = "sha256-ixHyG/w2h7tkaVYxmvpInfNW4AxVTn4Bflztzt1TOwM=";
    })
  ];

  pythonRelaxDeps = [ "async-timeout" ];

  build-system = [ setuptools ];

  dependencies = [
    async-timeout
    httpx
    httpx-socks
    python-socks
    rencode
  ]
  ++ python-socks.optional-dependencies.asyncio;

  nativeCheckInputs = [
    proxy-py
    pytest-asyncio
    pytest-mock
    pytestCheckHook
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
