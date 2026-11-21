{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  aiohttp,
  aiohttp-sse-client,
  charset-normalizer,
  dataclasses-json,
  oauth2-client,
}:

buildPythonPackage (finalAttrs: {
  pname = "home-connect-async";
  version = "0.8.8";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ekutner";
    repo = "home-connect-async";
    tag = finalAttrs.version;
    hash = "sha256-/Ote8EJ3/reixdpUnMj4cVIJ0wEwGxfkX27X7s+hOoA=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    aiohttp
    aiohttp-sse-client
    charset-normalizer
    dataclasses-json
    oauth2-client
  ];

  pythonImportsCheck = [
    "home_connect_async"
  ];

  meta = {
    description = "Async SDK for BSH Home Connect API";
    homepage = "https://github.com/ekutner/home-connect-async";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kranzes ];
  };
})
