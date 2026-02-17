{
  lib,
  aiohttp,
  bitstruct,
  buildPythonPackage,
  cryptography,
  fetchFromGitHub,
  pytest-asyncio,
  pytestCheckHook,
  setuptools,
  typing-extensions,
  voluptuous,
}:

buildPythonPackage (finalAttrs: {
  pname = "python-otbr-api";
  version = "2.8.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "home-assistant-libs";
    repo = "python-otbr-api";
    tag = finalAttrs.version;
    hash = "sha256-+Y07rSLIjBQiPuiXKDV5aQhA5mX9c9v7AGktL8rS4sc=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    bitstruct
    cryptography
    typing-extensions
    voluptuous
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "python_otbr_api" ];

  meta = {
    description = "Library for the Open Thread Border Router";
    homepage = "https://github.com/home-assistant-libs/python-otbr-api";
    changelog = "https://github.com/home-assistant-libs/python-otbr-api/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
