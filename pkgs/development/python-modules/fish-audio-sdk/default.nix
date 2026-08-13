{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  httpx,
  httpx-ws,
  ormsgpack,
  pydantic,
  typing-extensions,
  pytestCheckHook,
  pytest-asyncio,
  pytest-cov-stub,
}:

buildPythonPackage (finalAttrs: {
  pname = "fish-audio-sdk";
  version = "1.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "fishaudio";
    repo = "fish-audio-python";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Ht3lVuJE1wv+Ky/q5quhO8C4mkw6EO4LkO/wSevRUhg=";
  };

  build-system = [ hatchling ];

  dependencies = [
    httpx
    httpx-ws
    ormsgpack
    pydantic
    typing-extensions
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-asyncio
    pytest-cov-stub
  ];

  # tests require network access and a valid API key
  doCheck = false;

  pythonImportsCheck = [
    "fishaudio"
    "fish_audio_sdk"
  ];

  meta = {
    description = "Official Python library for the Fish Audio API";
    homepage = "https://github.com/fishaudio/fish-audio-python";
    changelog = "https://github.com/fishaudio/fish-audio-python/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
})
