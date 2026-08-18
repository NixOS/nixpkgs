{
  lib,
  aiohttp,
  aiointercept,
  aioresponses,
  buildPythonPackage,
  fetchFromGitHub,
  orjson,
  poetry-core,
  propcache,
  pytest-asyncio,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "nexia";
  version = "2.13.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "bdraco";
    repo = "nexia";
    tag = finalAttrs.version;
    hash = "sha256-jkyosr829jyR/aSDL9L+8xYZwwja0/TRETYFFBbwiFg=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    aiohttp
    orjson
    propcache
  ];

  nativeCheckInputs = [
    aiointercept
    aioresponses
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "nexia" ];

  meta = {
    description = "Python module for Nexia thermostats";
    homepage = "https://github.com/bdraco/nexia";
    changelog = "https://github.com/bdraco/nexia/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
})
