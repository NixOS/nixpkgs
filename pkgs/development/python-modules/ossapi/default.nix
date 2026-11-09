{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  aiohttp,
  osrparse,
  requests,
  requests-oauthlib,
  setuptools,
  typing-utils,
}:

buildPythonPackage (finalAttrs: {
  pname = "ossapi";
  version = "5.3.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Liam-DeVoe";
    repo = "ossapi";
    tag = "v${finalAttrs.version}";
    hash = "sha256-XppjM3WNdu4r3K0oARk/krPfPMiiCxwz2CYRCx8LphA=";
  };

  build-system = [ setuptools ];

  pythonRelaxDeps = [ "osrparse" ];

  dependencies = [
    osrparse
    requests
    requests-oauthlib
    typing-utils
  ];

  optional-dependencies = {
    async = [ aiohttp ];
  };

  # Tests require Internet access and an osu! API key
  doCheck = false;

  pythonImportsCheck = [ "ossapi" ];

  meta = {
    description = "Python wrapper for the osu! API";
    homepage = "https://github.com/Liam-DeVoe/ossapi";
    changelog = "https://github.com/Liam-DeVoe/ossapi/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ wulpine ];
  };
})
