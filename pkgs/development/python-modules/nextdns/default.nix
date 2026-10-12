{
  lib,
  aiohttp,
  aiointercept,
  aioresponses,
  buildPythonPackage,
  fetchFromGitHub,
  pyprojectVersionPatchHook,
  pytest-asyncio,
  pytest-error-for-skips,
  pytestCheckHook,
  setuptools,
  syrupy_6,
  tenacity,
}:

buildPythonPackage (finalAttrs: {
  pname = "nextdns";
  version = "5.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "bieniu";
    repo = "nextdns";
    tag = finalAttrs.version;
    hash = "sha256-+ih7QHmtQmWsi6HZZ3xepYBDYlCOyMKo0pQtr6oXpFs=";
  };

  build-system = [ setuptools ];

  nativeBuildInputs = [ pyprojectVersionPatchHook ];

  dependencies = [
    aiohttp
    tenacity
  ];

  nativeCheckInputs = [
    aiointercept
    aioresponses
    pytest-asyncio
    pytest-error-for-skips
    pytestCheckHook
    syrupy_6
  ];

  disabledTests = [
    # Test is outdated
    "test_valid_data"
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
