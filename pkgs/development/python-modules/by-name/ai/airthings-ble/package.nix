{
  lib,
  async-interrupt,
  bleak,
  bleak-retry-connector,
  buildPythonPackage,
  cbor2,
  fetchFromGitHub,
  poetry-core,
  pytest-cov-stub,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "airthings-ble";
  version = "1.1.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "vincegio";
    repo = "airthings-ble";
    tag = version;
    hash = "sha256-fZvmgRQuSrgraj6e3BtsoKyFX38BedqVh6cHsliT9ns=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    async-interrupt
    bleak
    bleak-retry-connector
    cbor2
  ];

  nativeCheckInputs = [
    pytest-cov-stub
    pytestCheckHook
  ];

  pythonImportsCheck = [ "airthings_ble" ];

  meta = with lib; {
    description = "Library for Airthings BLE devices";
    homepage = "https://github.com/vincegio/airthings-ble";
    changelog = "https://github.com/vincegio/airthings-ble/releases/tag/${src.tag}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
