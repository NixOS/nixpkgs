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
  version = "1.0.8";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "music-assistant";
    repo = "client";
    rev = version;
    hash = "sha256-QE2PQeXCAq7+iMomCZK+UmrPUApJxwKi/pzCaLJVS/4=";
  };

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
    changelog = "https://github.com/music-assistant/client/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ ];
  };
}
