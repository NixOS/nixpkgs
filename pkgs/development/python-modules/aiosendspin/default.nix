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
  pytest-xdist,
  pytestCheckHook,

  # meta
  music-assistant,

  nixosTests,
}:

buildPythonPackage (finalAttrs: {
  pname = "aiosendspin";
  version = "6.0.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Sendspin";
    repo = "aiosendspin";
    tag = finalAttrs.version;
    hash = "sha256-veX6MZSqEQb+tEqZTEgdCObLdaVPJEdTFW5Ivmb0TNQ=";
  };

  # https://github.com/Sendspin/aiosendspin/blob/5.3.0/pyproject.toml#L27
  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail 'version = "0.0.0"' 'version = "${finalAttrs.version}"'

    # too narrow timeouts, so remove pytest-timeout
    sed -i "/addopts/d" pyproject.toml
  '';

  build-system = [
    setuptools
  ];

  dependencies = [
    aiohttp
    mashumaro
    orjson
    zeroconf
  ];

  optional-dependencies = {
    server = [
      av
      numpy
      pillow
    ];
  };

  nativeCheckInputs = [
    pytest-aiohttp
    pytest-cov-stub
    pytest-xdist
    pytestCheckHook
  ]
  ++ finalAttrs.passthru.optional-dependencies.server;

  pythonImportsCheck = [
    "aiosendspin"
  ];

  passthru = {
    # needs manual compat testing with music-assistant (sendspin provider)
    skipBulkUpdate = true; # nixpkgs-update: no auto update
    tests = nixosTests.music-assistant;
  };

  meta = {
    changelog = "https://github.com/Sendspin/aiosendspin/releases/tag/${finalAttrs.src.tag}";
    description = "Async Python library implementing the Sendspin Protocol";
    homepage = "https://github.com/Sendspin/aiosendspin";
    license = lib.licenses.asl20;
    inherit (music-assistant.meta) maintainers;
  };
})
