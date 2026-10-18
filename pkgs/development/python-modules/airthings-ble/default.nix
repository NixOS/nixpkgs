{
  lib,
  async-interrupt,
  bleak,
  bleak-retry-connector,
  buildPythonPackage,
  cbor2,
  fetchFromGitHub,
  poetry-core,
  pytest-asyncio,
  pytest-cov-stub,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "airthings-ble";
  version = "1.3.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "vincegio";
    repo = "airthings-ble";
    tag = version;
    hash = "sha256-W9Cy5iOwQKDeyr40w/U4V61YyW7LprS24rxkHZL0OCY=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    async-interrupt
    bleak-retry-connector
    cbor2
  ]
  ++ lib.optionals (pythonOlder "3.14") [
    bleak
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytest-cov-stub
    pytestCheckHook
  ];

  pythonImportsCheck = [ "airthings_ble" ];

  meta = {
    description = "Library for Airthings BLE devices";
    homepage = "https://github.com/vincegio/airthings-ble";
    changelog = "https://github.com/vincegio/airthings-ble/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
