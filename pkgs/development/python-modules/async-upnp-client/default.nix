{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
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
  version = "0.44.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "StevenLooman";
    repo = "async_upnp_client";
    tag = version;
    hash = "sha256-xtouCq8nkvXxgZ0jX4VuTU41xxrAkXqWEpZg/vms4Zo=";
  };

  patches = [
    # Fix tests with latest aiohttp
    # FIXME: remove in next release
    (fetchpatch {
      url = "https://github.com/StevenLooman/async_upnp_client/commit/6ea1515890d588d353a9c263eca8fbf6571fbbec.diff";
      includes = [ "async_upnp_client/*" ];
      hash = "sha256-6DA+mIz76UE0xA0SSTGvhaf0dVAKT61ucsDeJDPoGAY=";
    })
  ];

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
