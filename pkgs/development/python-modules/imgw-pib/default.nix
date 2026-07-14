{
  aiofiles,
  aiohttp,
  aiointercept,
  aioresponses,
  buildPythonPackage,
  fetchFromGitHub,
  freezegun,
  lib,
  orjson,
  pytest-asyncio,
  pytestCheckHook,
  setuptools,
  syrupy,
}:

buildPythonPackage (finalAttrs: {
  pname = "imgw-pib";
  version = "2.4.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "bieniu";
    repo = "imgw-pib";
    tag = finalAttrs.version;
    hash = "sha256-KF9YQKGX6mTINZN09PNVLYFqMe1cITN4P9ge1Q+NGJk=";
  };

  build-system = [ setuptools ];

  pythonRelaxDeps = [
    "aiohttp"
  ];

  dependencies = [
    aiofiles
    aiohttp
    orjson
  ];

  pythonImportsCheck = [ "imgw_pib" ];

  nativeCheckInputs = [
    aiointercept
    aioresponses
    freezegun
    pytest-asyncio
    pytestCheckHook
    syrupy
  ];

  meta = {
    changelog = "https://github.com/bieniu/imgw-pib/releases/tag/${finalAttrs.src.tag}";
    description = "Python async wrapper for IMGW-PIB API";
    homepage = "https://github.com/bieniu/imgw-pib";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
})
