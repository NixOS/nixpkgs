{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch2,
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
  version = "24.6.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "esphome";
    repo = "aioesphomeapi";
    rev = "refs/tags/v${version}";
    hash = "sha256-T0E8lrire3rlPY3B3P3CqNWYV4SMvnOKKiiGTRoDz/s=";
  };

  patches = [
    (fetchpatch2 {
      url = "https://github.com/esphome/aioesphomeapi/commit/647dd99e0d04f017da41880e2fc299914ad5c762.diff";
      hash = "sha256-A0emzRj8AO7KF/XcAk0ysUvXO7v/tzvKGa63T5dzgTk=";
    })
  ];

  build-system = [
    setuptools
    cython
  ];

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
