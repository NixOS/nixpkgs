{
  aiodns,
  aiohttp,
  brotli,
  buildPythonPackage,
  faust-cchardet,
  fetchFromGitHub,
  lib,
  orjson,
  pyprojectVersionPatchHook,
  pytest-asyncio,
  pytest-cov-stub,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "hass-client";
  version = "1.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "music-assistant";
    repo = "python-hass-client";
    tag = finalAttrs.version;
    hash = "sha256-mrS3kuG/6ZE02B0Ua10AAAsgVBrEDRJxNfmIHT+EHWw=";
  };

  nativeBuildInputs = [
    pyprojectVersionPatchHook
  ];

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

  nativeCheckInputs = [
    pytest-asyncio
    pytest-cov-stub
    pytestCheckHook
  ];

  meta = {
    changelog = "https://github.com/music-assistant/python-hass-client/releases/tag/${finalAttrs.version}";
    description = "Basic client for connecting to Home Assistant over websockets and REST";
    homepage = "https://github.com/music-assistant/python-hass-client";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
})
