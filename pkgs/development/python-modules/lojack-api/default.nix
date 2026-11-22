{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  aiohttp,
  aioresponses,
  pytestCheckHook,
  pytest-asyncio,
}:

buildPythonPackage (finalAttrs: {
  pname = "lojack-api";
  version = "0.7.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "devinslick";
    repo = "lojack_api";
    tag = finalAttrs.version;
    hash = "sha256-QVXiIN+gb/jm5H49ByT8+jVgl3RVKPSgpwca04C6Keo=";
  };

  build-system = [ setuptools ];

  dependencies = [ aiohttp ];

  nativeCheckInputs = [
    aioresponses
    pytestCheckHook
    pytest-asyncio
  ];

  pythonImportsCheck = [ "lojack_api" ];

  meta = {
    description = "Async Python client library for the Spireon LoJack API";
    homepage = "https://github.com/devinslick/lojack_api";
    changelog = "https://github.com/devinslick/lojack_api/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
})
