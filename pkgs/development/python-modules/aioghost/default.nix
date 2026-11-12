{
  lib,
  aiohttp,
  aioresponses,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  pyjwt,
  pytest-aiohttp,
  pytest-asyncio,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "aioghost";
  version = "0.4.35";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "TryGhost";
    repo = "aioghost";
    tag = "v${finalAttrs.version}";
    hash = "sha256-81j2g1sC96WKVzJgKPkz46TZhHb6q2ORqhmb6UyE64s=";
  };

  build-system = [ hatchling ];

  dependencies = [
    aiohttp
    pyjwt
  ];

  nativeCheckInputs = [
    aioresponses
    pytest-aiohttp
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "aioghost" ];

  meta = {
    description = "Async Python client for the Ghost Admin API";
    homepage = "https://github.com/TryGhost/aioghost";
    changelog = "https://github.com/TryGhost/aioghost/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
})
