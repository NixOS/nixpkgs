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
  version = "2.19.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "fredrike";
    repo = "pydaikin";
    tag = "v${finalAttrs.version}";
    hash = "sha256-UY/pn8kCItUItehlfdbb5vA8wF8om90BgRYkYYYF2HE=";
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
