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
  version = "4.4.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Bluetooth-Devices";
    repo = "bleak-retry-connector";
    tag = "v${version}";
    hash = "sha256-/IJBAeb/PdJt0IbLm3RnaHn4o8o1DXN8jGiQtzp7wLg=";
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
