{
  lib,
  aiohttp,
  aioresponses,
  buildPythonPackage,
  fetchFromGitHub,
  pytest-asyncio,
  pytest-error-for-skips,
  pytestCheckHook,
  setuptools,
  syrupy,
  tenacity,
}:

buildPythonPackage (finalAttrs: {
  pname = "nextdns";
  version = "5.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "bieniu";
    repo = "nextdns";
    tag = finalAttrs.version;
    hash = "sha256-jZ+ULAlqaOnVWEHDPzIxIFjx+4eC3jMlXyX0QhfZUYM=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    tenacity
  ];

  nativeCheckInputs = [
    aioresponses
    pytest-asyncio
    pytest-error-for-skips
    pytestCheckHook
    syrupy
  ];

  pythonImportsCheck = [ "nextdns" ];

  meta = {
    description = "Module for the NextDNS API";
    homepage = "https://github.com/bieniu/nextdns";
    changelog = "https://github.com/bieniu/nextdns/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
})
