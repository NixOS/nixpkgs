{
  lib,
  buildPythonPackage,
  fetchFromGitea,
  aiobtclientrpc,
  async-timeout,
  httpx,
  torf,
  pytest-asyncio,
  pytest-mock,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "aiobtclientapi";
  version = "1.1.4";
  pyproject = true;

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "plotski";
    repo = "aiobtclientapi";
    tag = "v${version}";
    hash = "sha256-ga3EyKhfdEKkjFktUlgLSX54QbTc/a48vmWjmRqa+4w=";
  };

  pythonRelaxDeps = [
    "async-timeout"
  ];

  build-system = [
    setuptools
  ];

  dependencies = [
    aiobtclientrpc
    async-timeout
    httpx
    torf
  ];

  nativeCheckInputs = [
    pytest-asyncio
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
}
