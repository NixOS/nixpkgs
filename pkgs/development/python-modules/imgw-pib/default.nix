{
  aiofiles,
  aiohttp,
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
  version = "2.1.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "bieniu";
    repo = "imgw-pib";
    tag = finalAttrs.version;
    hash = "sha256-R1WhKOboItkKamO+hyyJyTl0veDCHDc4N70UE7IuFqI=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiofiles
    aiohttp
    orjson
  ];

  pythonImportsCheck = [ "imgw_pib" ];

  nativeCheckInputs = [
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
