{
  lib,
  aiohttp,
  orjson,
  faust-cchardet,
  aiodns,
  brotli,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "aiosonos";
  version = "0.1.12";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "music-assistant";
    repo = "aiosonos";
    tag = finalAttrs.version;
    hash = "sha256-uWg/2f1R7QUZLqE6zjcox7EHkyU14p9oRtrlaVy0EL8=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail 'version = "0.0.0"' 'version = "${finalAttrs.version}"'
  '';

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    orjson
    faust-cchardet
    aiodns
    brotli
  ];

  doCheck = false; # no tests

  pythonImportsCheck = [
    "aiosonos"
    "aiosonos.api"
  ];

  meta = {
    description = "Async python library to communicate with Sonos devices";
    homepage = "https://github.com/music-assistant/aiosonos";
    changelog = "https://github.com/music-assistant/aiosonos/releases/tag/${finalAttrs.src.tag}";
    license = [ lib.licenses.asl20 ];
    maintainers = [ lib.maintainers.autrimpo ];
  };
})
