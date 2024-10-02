{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,

  # build-system
  cython,
  setuptools,

  # dependencies
  aiohappyeyeballs,
  async-interrupt,
  async-timeout,
  chacha20poly1305-reuseable,
  cryptography,
  noiseprotocol,
  protobuf,
  zeroconf,

  # tests
  mock,
  pytest-asyncio,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "aioesphomeapi";
  version = "25.3.2";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "esphome";
    repo = "aioesphomeapi";
    rev = "refs/tags/v${version}";
    hash = "sha256-ITNXPwQTKOyH0TXYr8v/VI5rPNCvKGb/zIE1q+Ja8j0=";
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
    zeroconf
  ] ++ lib.optionals (pythonOlder "3.11") [ async-timeout ];

  nativeCheckInputs = [
    mock
    pytest-asyncio
    pytestCheckHook
  ];

  disabledTests = [
    # https://github.com/esphome/aioesphomeapi/issues/837
    "test_reconnect_logic_stop_callback"
    # python3.12.4 regression
    # https://github.com/esphome/aioesphomeapi/issues/889
    "test_start_connection_cannot_increase_recv_buffer"
    "test_start_connection_can_only_increase_buffer_size_to_262144"
  ];

  pythonImportsCheck = [ "aioesphomeapi" ];

  meta = with lib; {
    description = "Python Client for ESPHome native API";
    homepage = "https://github.com/esphome/aioesphomeapi";
    changelog = "https://github.com/esphome/aioesphomeapi/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [
      fab
      hexa
    ];
  };
}
