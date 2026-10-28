{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,

  # build-system
  cython,
  setuptools,

  # dependencies
  aiohappyeyeballs,
  async-interrupt,
  backports-zstd,
  chacha20poly1305-reuseable,
  cryptography,
  noiseprotocol,
  protobuf,
  tzdata,
  tzlocal,
  zeroconf,

  # tests
  mock,
  pytest-asyncio,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "aioesphomeapi";
  version = "46.23.0"; # must track the major version that home-assistant pins
  pyproject = true;

  src = fetchFromGitHub {
    owner = "esphome";
    repo = "aioesphomeapi";
    tag = "v${finalAttrs.version}";
    hash = "sha256-7n6K+MY0s2oOvnbUXrZA/PCamfpel1jYZr4RXzH+Y6s=";
  };

  build-system = [
    setuptools
    cython
  ];

  pythonRelaxDeps = [
    "aiohappyeyeballs"
    "cryptography"
  ];

  dependencies = [
    aiohappyeyeballs
    async-interrupt
    chacha20poly1305-reuseable
    cryptography
    noiseprotocol
    protobuf
    tzdata
    tzlocal
    zeroconf
  ]
  ++ lib.optionals (pythonOlder "3.14") [
    backports-zstd
  ];

  nativeCheckInputs = [
    mock
    pytest-asyncio
    pytestCheckHook
  ];

  # Lack of network sandboxing leads to conflicting listeners when testing
  # this package e.g. in nixpkgs-review on the two supported python package sets.
  doCheck = !stdenv.hostPlatform.isDarwin;

  disabledTestPaths = [
    # benchmarking requires pytest-codespeed
    "tests/benchmarks"
  ];

  __darwinAllowLocalNetworking = true;

  pythonImportsCheck = [ "aioesphomeapi" ];

  meta = {
    description = "Python Client for ESPHome native API";
    homepage = "https://github.com/esphome/aioesphomeapi";
    changelog = "https://github.com/esphome/aioesphomeapi/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      fab
      hexa
    ];
  };
})
