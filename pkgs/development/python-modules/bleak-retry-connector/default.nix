{
  lib,
  stdenv,
  bleak,
  blockbuster,
  bluetooth-adapters,
  buildPythonPackage,
  dbus-fast,
  fetchFromGitHub,
  poetry-core,
  pytest-asyncio,
  pytest-cov-stub,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "bleak-retry-connector";
  version = "4.6.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Bluetooth-Devices";
    repo = "bleak-retry-connector";
    tag = "v${finalAttrs.version}";
    hash = "sha256-SGQ+9HjD6VhxZwmjh1K/EHbUIFE/bbtLBwmauU/IEJM=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    bleak
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    dbus-fast
    bluetooth-adapters
  ];

  nativeCheckInputs = [
    blockbuster
    pytest-asyncio
    pytest-cov-stub
    pytestCheckHook
  ];

  # ModuleNotFoundError: No module named 'dbus_fast'
  doCheck = stdenv.hostPlatform.isLinux;

  pythonImportsCheck = [ "bleak_retry_connector" ];

  meta = {
    description = "Connector for Bleak Clients that handles transient connection failures";
    homepage = "https://github.com/bluetooth-devices/bleak-retry-connector";
    changelog = "https://github.com/Bluetooth-Devices/bleak-retry-connector/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
