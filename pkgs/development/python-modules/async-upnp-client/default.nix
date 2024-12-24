{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,

  # build-system
  setuptools,

  # dependencies
  aiohttp,
  async-timeout,
  defusedxml,
  python-didl-lite,
  voluptuous,

  # tests
  pytest-aiohttp,
  pytest-asyncio,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "async-upnp-client";
  version = "0.42.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "StevenLooman";
    repo = "async_upnp_client";
    rev = "refs/tags/${version}";
    hash = "sha256-xIa7QeflS7JxkPoV8KqFfuLfHPpnrBGLeOFSa17IHyk=";
  };

  pythonRelaxDeps = [ "defusedxml" ];

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    async-timeout
    defusedxml
    python-didl-lite
    voluptuous
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-aiohttp
    pytest-asyncio
  ];

  disabledTests = [
    # socket.gaierror: [Errno -2] Name or service not known
    "test_async_get_local_ip"
    "test_get_local_ip"
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin [ "test_deferred_callback_url" ];

  disabledTestPaths = [
    # Tries to bind to multicast socket and fails to find proper interface
    "tests/test_ssdp_listener.py"
  ];

  pythonImportsCheck = [ "async_upnp_client" ];

  meta = with lib; {
    description = "Asyncio UPnP Client library for Python";
    homepage = "https://github.com/StevenLooman/async_upnp_client";
    changelog = "https://github.com/StevenLooman/async_upnp_client/blob/${version}/CHANGES.rst";
    license = licenses.asl20;
    maintainers = with maintainers; [ hexa ];
    mainProgram = "upnp-client";
  };
}
