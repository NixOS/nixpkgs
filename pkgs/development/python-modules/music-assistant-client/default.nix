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
  version = "1.3.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "music-assistant";
    repo = "client";
    tag = version;
    hash = "sha256-uK3suOFhRJT6ji5ksdH3Y4iO9ysdbyZWVNTThJvGiGc=";
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
    changelog = "https://github.com/music-assistant/client/releases/tag/${src.tag}";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
}
