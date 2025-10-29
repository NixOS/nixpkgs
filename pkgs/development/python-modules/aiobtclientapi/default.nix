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
  version = "1.1.3";
  pyproject = true;

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "plotski";
    repo = "aiobtclientapi";
    tag = "v${version}";
    hash = "sha256-ZpUaMsJs1vdVGQOid7aJ+SJKaCbTtHfSw7cOwPTL0ss=";
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
