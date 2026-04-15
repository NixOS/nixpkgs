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
  numpy,
  orjson,
  pillow,
  zeroconf,

  # test dependencies
  pytest-aiohttp,
  pytest-cov-stub,
  pytest-timeout,
  pytest-xdist,
  pytestCheckHook,

  # meta
  music-assistant,

  nixosTests,
}:

buildPythonPackage rec {
  pname = "aiosendspin";
  version = "4.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Sendspin";
    repo = "aiosendspin";
    tag = version;
    hash = "sha256-7edFCGNbECW5rrTbF7vJ4lJUc2IrQZD9VTR3IxJRP08=";
  };

  # https://github.com/Sendspin/aiosendspin/blob/4.4.0/pyproject.toml#L7
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
    numpy
    orjson
    pillow
    zeroconf
  ];

  nativeCheckInputs = [
    pytest-aiohttp
    pytest-cov-stub
    pytest-timeout
    pytest-xdist
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "aiosendspin"
  ];

  passthru = {
    # needs manual compat testing with music-assistant (sendspin provider)
    skipBulkUpdate = true; # nixpkgs-update: no auto update
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
