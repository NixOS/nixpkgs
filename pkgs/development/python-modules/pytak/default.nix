{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  cryptography,
  aiohttp,
  pytestCheckHook,
  pytest-asyncio,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "pytak";
  version = "7.6.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "snstac";
    repo = "pytak";
    tag = "v${finalAttrs.version}";
    hash = "sha256-BzX5B8Gavpini1oLtQ+Dal31BpW8SGlwg7OO9r1Of+A=";
  };

  build-system = [ setuptools ];

  dependencies = [
    cryptography
    aiohttp
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-asyncio
    writableTmpDirAsHomeHook
  ];

  disabledTests = [
    # require network access -> Network is unreachable
    "test_protocol_factory_udp_multicast"
    "test_protocol_factory_udp_multicast_wo"
    "test_protocol_factory_udp_multicast_ro"
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    "test_reuseaddr_is_set_before_bind"
    "test_second_subscriber_can_bind"
  ];

  # Tests need to resolve localhost and bind local sockets
  __darwinAllowLocalNetworking = true;

  pythonImportsCheck = [ "pytak" ];

  meta = {
    description = "Python package for rapid Team Awareness Kit (TAK) integration";
    homepage = "https://pytak.readthedocs.io";
    changelog = "https://github.com/snstac/pytak/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ felbinger ];
  };
})
