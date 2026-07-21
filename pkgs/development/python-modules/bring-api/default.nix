{
  lib,
  aiohttp,
  aioresponses,
  buildPythonPackage,
  fetchFromGitHub,
  mashumaro,
  orjson,
  pytest-asyncio,
  pytestCheckHook,
  python-dotenv,
  setuptools,
  syrupy,
}:

buildPythonPackage (finalAttrs: {
  pname = "bring-api";
  version = "1.1.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "miaucl";
    repo = "bring-api";
    tag = finalAttrs.version;
    hash = "sha256-EwOb+AkjpJSpINFmfWNDqRPF7MDpwDa0LK3LFj7U/sY=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    mashumaro
    orjson
  ];

  nativeCheckInputs = [
    aioresponses
    pytest-asyncio
    pytestCheckHook
    python-dotenv
    syrupy
  ];

  pythonImportsCheck = [ "bring_api" ];

  meta = {
    description = "Module to access the Bring! shopping lists API";
    homepage = "https://github.com/miaucl/bring-api";
    changelog = "https://github.com/miaucl/bring-api/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
