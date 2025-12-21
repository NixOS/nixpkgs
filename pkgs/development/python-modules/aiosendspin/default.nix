{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  aiohttp,
  av,
  mashumaro,
  orjson,
  pillow,
  zeroconf,

  # meta
  music-assistant,
}:

buildPythonPackage rec {
  pname = "aiosendspin";
  version = "1.1.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Sendspin";
    repo = "aiosendspin";
    tag = version;
    hash = "sha256-/Li8EOH814D/1TiVVNy2khCYJVoLD1mL7pYIuZ7UX6Q=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    aiohttp
    av
    mashumaro
    orjson
    pillow
    zeroconf
  ];

  doCheck = false; # no tests

  pythonImportsCheck = [
    "aiosendspin"
  ];

  meta = {
    changelog = "https://github.com/Sendspin/aiosendspin/releases/tag/${src.tag}";
    description = "Async Python library implementing the Sendspin Protocol";
    homepage = "https://github.com/Sendspin/aiosendspin";
    license = lib.licenses.asl20;
    inherit (music-assistant.meta) maintainers;
  };
}
