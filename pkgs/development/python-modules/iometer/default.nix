{
  aiohttp,
  aiohttp-sse-client,
  aioresponses,
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  poetry-core,
  pyprojectVersionPatchHook,
  pytest-asyncio,
  pytestCheckHook,
  yarl,
}:

buildPythonPackage (finalAttrs: {
  pname = "iometer";
  version = "1.0.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "energy-smart-control";
    repo = "iometer.py";
    tag = "v${finalAttrs.version}";
    hash = "sha256-qXzj0aZrbca2q/KE+yS6aQ9N6tT5u6Siq/hvSCeYoAY=";
  };

  nativeBuildInputs = [ pyprojectVersionPatchHook ];

  build-system = [ poetry-core ];

  dependencies = [
    aiohttp
    aiohttp-sse-client
    yarl
  ];

  pythonImportsCheck = [ "iometer" ];

  nativeCheckInputs = [
    aioresponses
    pytest-asyncio
    pytestCheckHook
  ];

  enabledTestPaths = [
    "tests/test.py"
  ];

  meta = {
    changelog = "https://github.com/energy-smart-control/iometer.py/releases/tag/${finalAttrs.src.tag}";
    description = "Python client for interacting with IOmeter devices over HTTP";
    homepage = "https://github.com/energy-smart-control/iometer.py";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
})
