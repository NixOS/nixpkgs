{
  lib,
  aiohttp,
  buildPythonPackage,
  dnspython,
  fetchFromGitHub,
  pytest-asyncio_0,
  pytestCheckHook,
  pythonAtLeast,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "pykaleidescape";
  version = "1.1.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "SteveEasley";
    repo = "pykaleidescape";
    tag = "v${finalAttrs.version}";
    hash = "sha256-irXm1kX9gy6XU1PWvFKG2IeUE7raKI2C0I6Vge1ZKsI=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    dnspython
  ];

  nativeCheckInputs = [
    pytest-asyncio_0
    pytestCheckHook
  ];

  pythonImportsCheck = [ "kaleidescape" ];

  disabledTests = [
    # Test requires network access
    "test_resolve_succeeds"
  ]
  ++ lib.optionals (pythonAtLeast "3.12") [
    # stuck in EpollSelector.poll()
    "test_manual_disconnect"
    "test_concurrency"
    "test_reconnect_calls_on_reconnect"
    "test_refresh_after_reconnect"
  ];

  meta = {
    description = "Module for controlling Kaleidescape devices";
    homepage = "https://github.com/SteveEasley/pykaleidescape";
    changelog = "https://github.com/SteveEasley/pykaleidescape/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
