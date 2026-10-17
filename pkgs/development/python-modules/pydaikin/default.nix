{
  lib,
  aiohttp,
  aresponses,
  buildPythonPackage,
  fetchFromGitHub,
  freezegun,
  psutil,
  pytest-asyncio,
  pytestCheckHook,
  urllib3,
  setuptools,
  tenacity,
}:

buildPythonPackage (finalAttrs: {
  pname = "pydaikin";
  version = "2.20.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "fredrike";
    repo = "pydaikin";
    tag = "v${finalAttrs.version}";
    hash = "sha256-hkKtfDU2FPj1KeOd/N9hyEESfsYGdXj7YZC9CYuOQ0g=";
  };

  __darwinAllowLocalNetworking = true;

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    psutil
    urllib3
    tenacity
  ];

  nativeCheckInputs = [
    aresponses
    freezegun
    pytest-asyncio
    pytestCheckHook
  ];

  disabledTests = [
    # Failed: async def functions are not natively supported.
    "test_update_status_dry_comfort_offset"
  ];

  pythonImportsCheck = [ "pydaikin" ];

  meta = {
    description = "Python Daikin HVAC appliances interface";
    homepage = "https://github.com/fredrike/pydaikin";
    changelog = "https://github.com/fredrike/pydaikin/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "pydaikin";
  };
})
