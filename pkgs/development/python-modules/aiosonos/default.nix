{
  lib,
  aiodns,
  aiohttp,
  brotli,
  buildPythonPackage,
  faust-cchardet,
  fetchFromGitHub,
  orjson,
  pyprojectVersionPatchHook,
  pytest-asyncio,
  pytest-cov-stub,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "aiosonos";
  version = "0.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "music-assistant";
    repo = "aiosonos";
    tag = finalAttrs.version;
    hash = "sha256-bc1zNBqXPgonmRucZxLbI6xb0vnBTysukQ2SPHPfOog=";
  };

  build-system = [ setuptools ];

  nativeBuildInputs = [ pyprojectVersionPatchHook ];

  dependencies = [
    aiohttp
    orjson
    faust-cchardet
    aiodns
    brotli
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytest-cov-stub
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "aiosonos"
    "aiosonos.api"
  ];

  meta = {
    description = "Async python library to communicate with Sonos devices";
    homepage = "https://github.com/music-assistant/aiosonos";
    changelog = "https://github.com/music-assistant/aiosonos/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.autrimpo ];
  };
})
