{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  cython,
  setuptools,

  # dependencies
  aiohappyeyeballs,
  async-interrupt,
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
  version = "45.6.1"; # must track the major version that home-assistant pins
  pyproject = true;

  src = fetchFromGitHub {
    owner = "esphome";
    repo = "aioesphomeapi";
    tag = "v${finalAttrs.version}";
    hash = "sha256-pjpc3lHORiFID5spq8x0cH1JUdee8CJHUDxdP9pC3RA=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "setuptools>=82.0.1" setuptools \
      --replace-fail "Cython>=3.2.6" Cython
  '';

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
