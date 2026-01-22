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
  version = "2.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Sendspin";
    repo = "aiosendspin";
    tag = version;
    hash = "sha256-9VhNtfXH2r/cGkscz51PIK2/66pPOGv0S0IpO0wFvO4=";
  };

  # https://github.com/Sendspin/aiosendspin/blob/1.2.0/pyproject.toml#L7
  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail 'version = "0.0.0"' 'version = "${version}"'
  '';

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
