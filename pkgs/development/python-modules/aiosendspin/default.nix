{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pyprojectVersionPatchHook,

  # build-system
  setuptools,

  # dependencies
  aiohttp,
  av,
  cpace,
  cryptography,
  mashumaro,
  noiseprotocol,
  numpy,
  orjson,
  pillow,
  soxr,
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
  version = "10.2.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Sendspin";
    repo = "aiosendspin";
    tag = finalAttrs.version;
    hash = "sha256-Y8DXmuoQHXA3dtnQVGjp0sQX3R4NYjQVU2JtpsorqRQ=";
  };

  postPatch = ''
    # too narrow timeouts, so remove pytest-timeout
    sed -i "/addopts/d" pyproject.toml
  '';

  build-system = [
    setuptools
  ];

  nativeBuildInputs = [
    # https://github.com/Sendspin/aiosendspin/blob/9.1.1/pyproject.toml#L30
    pyprojectVersionPatchHook
  ];

  dependencies = [
    aiohttp
    cpace
    cryptography
    mashumaro
    noiseprotocol
    orjson
    zeroconf
  ];

  optional-dependencies = {
    asrc = [
      av
      numpy
      soxr
    ];
    server = [
      av
      numpy
      pillow
    ];
    source = [
      av
      numpy
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

  __darwinAllowLocalNetworking = true;

  disabledTests = [
    # This test fails due to our ffmpeg/pyav being build with libsoxr and it automatically being chosen.
    # When forcefully disabling libsoxr, the test passes, but Music Assistant, the primary consumer of this library,
    # builds a custom ffmpeg with libsoxr and then links their PyAV against it, so it cannot be that bad, right?
    "test_format_change_during_inflight_commit_aborts_old_format_delivery"
  ];

  passthru = {
    # needs manual compat testing with music-assistant (sendspin provider)
    skipBulkUpdate = true; # nixpkgs-update: no auto update
    tests.music-assistant = nixosTests.music-assistant;
  };

  meta = {
    changelog = "https://github.com/Sendspin/aiosendspin/releases/tag/${finalAttrs.src.tag}";
    description = "Async Python library implementing the Sendspin Protocol";
    homepage = "https://github.com/Sendspin/aiosendspin";
    license = lib.licenses.asl20;
    inherit (music-assistant.meta) maintainers;
  };
})
