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
  version = "1.1.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "SteveEasley";
    repo = "pykaleidescape";
    tag = "v${finalAttrs.version}";
    hash = "sha256-IA6BefKBFMfatiaw+Ye8NdYZ6BDlR1z4L+YkZ4Iy3Wg=";
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
  ];

  meta = {
    description = "Module for controlling Kaleidescape devices";
    homepage = "https://github.com/SteveEasley/pykaleidescape";
    changelog = "https://github.com/SteveEasley/pykaleidescape/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
