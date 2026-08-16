{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  hatch-vcs,
  defusedxml,
  pytest-asyncio,
  pytest-vcr,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "afsapi";
  version = "1.0.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "wlcrs";
    repo = "python-afsapi";
    tag = finalAttrs.version;
    hash = "sha256-ZfP8LboBDrxXULtocOTZJ0Ku/zgear4NW5ckcHUKXc4=";
  };

  build-system = [
    hatchling
    hatch-vcs
  ];

  dependencies = [
    aiohttp
    defusedxml
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytest-vcr
    pytestCheckHook
  ];

  disabledTestPaths = [
    # Failed: async def functions are not natively supported.
    "async_tests.py"
    # requires local device
    "tests/test_device_recordings.py"
    "tests/test_device_recordings_write.py"
  ];

  pythonImportsCheck = [ "afsapi" ];

  meta = {
    changelog = "https://github.com/wlcrs/python-afsapi/releases/tag/${finalAttrs.version}";
    description = "Python implementation of the Frontier Silicon API";
    homepage = "https://github.com/wlcrs/python-afsapi";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
})
