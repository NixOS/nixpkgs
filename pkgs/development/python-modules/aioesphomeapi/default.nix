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
  tzlocal,
  zeroconf,

  # tests
  mock,
  pytest-asyncio,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "aioesphomeapi";
  version = "43.14.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "esphome";
    repo = "aioesphomeapi";
    tag = "v${finalAttrs.version}";
    hash = "sha256-SuJNGRaXWq7KDMshq46oKSVD+1eVUqOhy9D/R3OLeys=";
  };

  build-system = [
    setuptools
    cython
  ];

  pythonRelaxDeps = [ "cryptography" ];

  dependencies = [
    aiohappyeyeballs
    async-interrupt
    chacha20poly1305-reuseable
    cryptography
    noiseprotocol
    protobuf
    tzlocal
    zeroconf
  ];

  nativeCheckInputs = [
    mock
    pytest-asyncio
    pytestCheckHook
  ];

  # Lack of network sandboxing leads to conflicting listeners when testing
  # this package e.g. in nixpkgs-review on the two suppoted python package sets.
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
