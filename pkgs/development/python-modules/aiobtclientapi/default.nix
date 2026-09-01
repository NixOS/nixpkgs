{
  lib,
  buildPythonPackage,
  fetchFromCodeberg,
  aiobtclientrpc,
  async-timeout,
  httpx,
  torf,
  pytest-asyncio,
  pytest-cov-stub,
  pytest-mock,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "aiobtclientapi";
  version = "2.0.1";
  pyproject = true;

  src = fetchFromCodeberg {
    owner = "plotski";
    repo = "aiobtclientapi";
    tag = "v${finalAttrs.version}";
    hash = "sha256-7LpLkbN1PJCLOGjPm3HN2LWS0JeFzP7se6NGEtZb6uk=";
  };

  pythonRelaxDeps = [ "async-timeout" ];

  build-system = [ setuptools ];

  dependencies = [
    aiobtclientrpc
    async-timeout
    httpx
    torf
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytest-cov-stub
    pytest-mock
    pytestCheckHook
  ];

  pythonImportsCheck = [ "aiobtclientapi" ];

  disabledTests = [
    # Timing-sensitive, e.g. "AssertionError: assert 9 <= 7"
    "test_Monitor_block_until_timeout"
  ];

  disabledTestPaths = [
    # AttributeError
    "tests/clients_test/rtorrent_test/rtorrent_api_test.py"
  ];

  meta = {
    description = "Asynchronous high-level communication with BitTorrent clients";
    homepage = "https://aiobtclientapi.readthedocs.io";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ ambroisie ];
  };
})
