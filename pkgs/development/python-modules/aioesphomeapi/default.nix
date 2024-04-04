{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder

# build-system
, cython_3
, setuptools

# dependencies
, aiohappyeyeballs
, async-interrupt
, async-timeout
, chacha20poly1305-reuseable
, cryptography
, noiseprotocol
, protobuf
, zeroconf

# tests
, mock
, pytest-asyncio
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "aioesphomeapi";
  version = "23.2.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "esphome";
    repo = "aioesphomeapi";
    rev = "refs/tags/v${version}";
    hash = "sha256-GFQ87Ic0xHXs8ZgmzH7kOFbDSNmtj0hx+YHKnrz/sG0=";
  };

  build-system = [
    setuptools
    cython_3
  ];

  dependencies = [
    aiohappyeyeballs
    async-interrupt
    chacha20poly1305-reuseable
    cryptography
    noiseprotocol
    protobuf
    zeroconf
  ] ++ lib.optionals (pythonOlder "3.11") [
    async-timeout
  ];

  nativeCheckInputs = [
    mock
    pytest-asyncio
    pytestCheckHook
  ];

  disabledTests = [
    # https://github.com/esphome/aioesphomeapi/issues/837
    "test_reconnect_logic_stop_callback"
  ];

  pythonImportsCheck = [
    "aioesphomeapi"
  ];

  meta = with lib; {
    description = "Python Client for ESPHome native API";
    homepage = "https://github.com/esphome/aioesphomeapi";
    changelog = "https://github.com/esphome/aioesphomeapi/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab hexa ];
  };
}
