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
  stdenv,
}:

buildPythonPackage rec {
  pname = "bleak-retry-connector";
  version = "4.5.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Bluetooth-Devices";
    repo = "bleak-retry-connector";
    tag = "v${version}";
    hash = "sha256-aGk5wNrQ8ti2qu1FxmOqPtDpivm5DRaKvwzDNz9rFmQ=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    bleak
    dbus-fast
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    bluetooth-adapters
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytest-cov-stub
    pytestCheckHook
  ];

  pythonImportsCheck = [ "bleak_retry_connector" ];

  meta = {
    description = "Connector for Bleak Clients that handles transient connection failures";
    homepage = "https://github.com/bluetooth-devices/bleak-retry-connector";
    changelog = "https://github.com/Bluetooth-Devices/bleak-retry-connector/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
