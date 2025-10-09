{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,

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
  version = "0.45.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "StevenLooman";
    repo = "async_upnp_client";
    tag = version;
    hash = "sha256-bRUEnedPDFBgpJeDPRG6e6fQUJ/R2RaasVKHZX7COp8=";
  };

  pythonRelaxDeps = [
    "async-timeout"
    "defusedxml"
  ];

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
    "test_decode_ssdp_packet"
    "test_microsoft_butchers_ssdp"
    # socket.gaierror: [Errno -2] Name or service not known
    "test_async_get_local_ip"
    "test_get_local_ip"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [ "test_deferred_callback_url" ];

  disabledTestPaths = [
    # Tries to bind to multicast socket and fails to find proper interface
    "tests/test_ssdp_listener.py"
  ];

  pythonImportsCheck = [ "async_upnp_client" ];

  meta = {
    description = "Asyncio UPnP Client library for Python";
    homepage = "https://github.com/StevenLooman/async_upnp_client";
    changelog = "https://github.com/StevenLooman/async_upnp_client/blob/${src.tag}/CHANGES.rst";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ hexa ];
    mainProgram = "upnp-client";
  };
}
