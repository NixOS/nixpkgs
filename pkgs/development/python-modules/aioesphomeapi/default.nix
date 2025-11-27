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

buildPythonPackage rec {
  pname = "aioesphomeapi";
  version = "42.8.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "esphome";
    repo = "aioesphomeapi";
    tag = "v${version}";
    hash = "sha256-33QldAjCuuZr/aqAN3chq57lKzfE8n0ZXybtrAoW4tc=";
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

  meta = with lib; {
    description = "Python Client for ESPHome native API";
    homepage = "https://github.com/esphome/aioesphomeapi";
    changelog = "https://github.com/esphome/aioesphomeapi/releases/tag/${src.tag}";
    license = licenses.mit;
    maintainers = with maintainers; [
      fab
      hexa
    ];
  };
}
