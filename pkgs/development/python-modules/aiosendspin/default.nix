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

  nixosTests,
}:

buildPythonPackage rec {
  pname = "aiosendspin";
  version = "4.3.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Sendspin";
    repo = "aiosendspin";
    tag = version;
    hash = "sha256-XIrDQbM0UR7YPf00MlEcR5Wq1Cj1niVOF8fudSfd2to=";
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

  # needs manual compat testing with music-assistant (sendspin provider)
  passthru = {
    tests = nixosTests.music-assistant;
  };

  meta = {
    changelog = "https://github.com/Sendspin/aiosendspin/releases/tag/${src.tag}";
    description = "Async Python library implementing the Sendspin Protocol";
    homepage = "https://github.com/Sendspin/aiosendspin";
    license = lib.licenses.asl20;
    inherit (music-assistant.meta) maintainers;
  };
}
