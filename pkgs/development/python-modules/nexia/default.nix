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
  version = "2.12.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "bdraco";
    repo = "nexia";
    tag = finalAttrs.version;
    hash = "sha256-d3mV7kzUoM6JvZ82FLNxapkRZDjFH7V/rf4qjIyf2is=";
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
