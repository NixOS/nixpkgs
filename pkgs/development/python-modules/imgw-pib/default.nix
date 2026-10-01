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
  pyprojectVersionPatchHook,
  pytest-asyncio,
  pytestCheckHook,
  setuptools,
  syrupy_6,
}:

buildPythonPackage (finalAttrs: {
  pname = "imgw-pib";
  version = "2.5.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "bieniu";
    repo = "imgw-pib";
    tag = finalAttrs.version;
    hash = "sha256-gA3SGINITBcVf0oBOB90JXpeAGCs3FkH+56CCryO1NE=";
  };

  build-system = [ setuptools ];

  nativeBuildInputs = [
    pyprojectVersionPatchHook
  ];

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
    syrupy_6
  ];

  meta = {
    changelog = "https://github.com/bieniu/imgw-pib/releases/tag/${finalAttrs.src.tag}";
    description = "Python async wrapper for IMGW-PIB API";
    homepage = "https://github.com/bieniu/imgw-pib";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
})
