{
  lib,
  aiohttp,
  aresponses,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pytest-aiohttp,
  pytest-asyncio,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "aioflo";
  version = "2026.09.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "bachya";
    repo = "aioflo";
    tag = finalAttrs.version;
    hash = "sha256-VZ0kHqv+SAZ5JfXJRN6kFFYl2V5ahJJCDdf1kdzIj/Q=";
  };

  build-system = [ poetry-core ];

  dependencies = [ aiohttp ];

  __darwinAllowLocalNetworking = true;

  nativeCheckInputs = [
    aresponses
    pytest-aiohttp
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "aioflo" ];

  meta = {
    description = "Python library for Flo by Moen Smart Water Detectors";
    homepage = "https://github.com/bachya/aioflo";
    changelog = "https://github.com/bachya/aioflo/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
