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
  version = "5.3.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Liam-DeVoe";
    repo = "ossapi";
    tag = "v${finalAttrs.version}";
    hash = "sha256-gkees4d12vCfx5KGNKm9NjW5XmRw+xJy2RISMOKzG+s=";
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
