{
  lib,
  aiohttp,
  aioresponses,
  bleak,
  bleak-retry-connector,
  buildPythonPackage,
  cryptography,
  fetchFromGitHub,
  mashumaro,
  pytest-asyncio,
  pytestCheckHook,
  setuptools,
  syrupy,
}:

buildPythonPackage (finalAttrs: {
  pname = "pylamarzocco";
  version = "2.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "zweckj";
    repo = "pylamarzocco";
    tag = "v${finalAttrs.version}";
    hash = "sha256-DNlUdnJjaYUfz8X8UmzqjHwj+WGmRQZQGDkHUjrAJ7E=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    bleak
    bleak-retry-connector
    cryptography
    mashumaro
  ];

  nativeCheckInputs = [
    aioresponses
    pytest-asyncio
    pytestCheckHook
    syrupy
  ];

  pythonImportsCheck = [ "pylamarzocco" ];

  meta = {
    description = "Library to interface with La Marzocco's cloud";
    homepage = "https://github.com/zweckj/pylamarzocco";
    changelog = "https://github.com/zweckj/pylamarzocco/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
