{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  hatch-vcs,
  defusedxml,
  pytest-aiohttp,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "afsapi";
  version = "1.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "wlcrs";
    repo = "python-afsapi";
    tag = finalAttrs.version;
    hash = "sha256-5gvA3rFyAlTx7oKrUq9q0lBuwatzMPvRhjy7GYnwdik=";
  };

  build-system = [
    hatchling
    hatch-vcs
  ];

  dependencies = [
    aiohttp
    defusedxml
  ];

  doCheck = false; # Failed: async def functions are not natively supported.

  nativeCheckInputs = [
    pytest-aiohttp
    pytestCheckHook
  ];

  enabledTestPaths = [ "async_tests.py" ];

  pythonImportsCheck = [ "afsapi" ];

  meta = {
    changelog = "https://github.com/wlcrs/python-afsapi/releases/tag/${finalAttrs.version}";
    description = "Python implementation of the Frontier Silicon API";
    homepage = "https://github.com/wlcrs/python-afsapi";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
})
