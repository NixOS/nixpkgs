{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  pycryptodome,
  pytest-asyncio,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "aioairq";
  version = "0.6.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "CorantGmbH";
    repo = "aioairq";
    tag = "v${finalAttrs.version}";
    hash = "sha256-I8pbNYbSWns0fbJvgJ71AZK0SzpY/51MXLr7+D5/xF4=";
  };

  __darwinAllowLocalNetworking = true;

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    pycryptodome
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "aioairq" ];

  disabledTestPaths = [
    # Tests require network access
    "tests/test_core_on_device.py"
  ];

  meta = {
    description = "Library to retrieve data from air-Q devices";
    homepage = "https://github.com/CorantGmbH/aioairq";
    changelog = "https://github.com/CorantGmbH/aioairq/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
})
