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
  version = "0.4.23";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "TryGhost";
    repo = "aioghost";
    tag = "v${finalAttrs.version}";
    hash = "sha256-bgWBZvkHkUE1o2a6L6vC1YK41Da0SayPhTLJeTbnYxk=";
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
