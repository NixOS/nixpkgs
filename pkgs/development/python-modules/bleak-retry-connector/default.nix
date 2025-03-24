{
  lib,
  bleak,
  bluetooth-adapters,
  dbus-fast,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pytestCheckHook,
  pytest-asyncio,
  pytest-cov-stub,
}:

buildPythonPackage rec {
  pname = "bleak-retry-connector";
  version = "3.9.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Bluetooth-Devices";
    repo = "bleak-retry-connector";
    tag = "v${version}";
    hash = "sha256-weZ44YhbCoDRByzta/tkl1maEuxewS+53jxFRDHK6so=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    bleak
    bluetooth-adapters
    dbus-fast
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytest-cov-stub
    pytestCheckHook
  ];

  pythonImportsCheck = [ "bleak_retry_connector" ];

  meta = with lib; {
    description = "Connector for Bleak Clients that handles transient connection failures";
    homepage = "https://github.com/bluetooth-devices/bleak-retry-connector";
    changelog = "https://github.com/bluetooth-devices/bleak-retry-connector/blob/${src.tag}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
