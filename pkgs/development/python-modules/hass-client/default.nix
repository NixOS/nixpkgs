{
  aiodns,
  aiohttp,
  brotli,
  buildPythonPackage,
  faust-cchardet,
  fetchFromGitHub,
  lib,
  orjson,
  setuptools,
}:

buildPythonPackage rec {
  pname = "hass-client";
  version = "1.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "music-assistant";
    repo = "python-hass-client";
    rev = "refs/tags/${version}";
    hash = "sha256-FA3acaXLWcBMDsabLPxVk6EArSxcTAnmFeO1ixTXB1Q=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    aiohttp
  ];

  optional-dependencies = {
    speedups = [
      aiodns
      brotli
      faust-cchardet
      orjson
    ];
  };

  pythonImportsCheck = [
    "hass_client"
  ];

  # upstream has no tests
  doCheck = false;

  meta = {
    changelog = "https://github.com/music-assistant/python-hass-client/releases/tag/${version}";
    description = "Basic client for connecting to Home Assistant over websockets and REST";
    homepage = "https://github.com/music-assistant/python-hass-client";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
