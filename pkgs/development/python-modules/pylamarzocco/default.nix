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

buildPythonPackage rec {
  pname = "pylamarzocco";
  version = "2.2.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "zweckj";
    repo = "pylamarzocco";
    tag = "v${version}";
    hash = "sha256-ayu2Cx6lSgiYdg9XszdA3v3pWeKkgAiA7LHOB0KlS5I=";
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
    changelog = "https://github.com/zweckj/pylamarzocco/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
