{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  aiohttp,
  music-assistant-models,
  orjson,

}:

buildPythonPackage rec {
  pname = "music-assistant-client";
  version = "1.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "music-assistant";
    repo = "client";
    tag = version;
    hash = "sha256-i3VIRK3RUgbF5KX3U7i4WwjbLaRvg88zUH5Ly8BKEB0=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "0.0.0" "${version}"
  '';

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    music-assistant-models
    orjson
  ];

  doCheck = false; # no tests

  pythonImportsCheck = [
    "music_assistant_client"
  ];

  meta = {
    description = "Python client to interact with the Music Assistant Server API";
    homepage = "https://github.com/music-assistant/client";
    changelog = "https://github.com/music-assistant/client/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ ];
  };
}
