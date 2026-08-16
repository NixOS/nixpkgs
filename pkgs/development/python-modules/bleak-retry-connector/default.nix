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
  version = "4.6.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Bluetooth-Devices";
    repo = "bleak-retry-connector";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ZSnqlly0LeHSQF45XA8NPjVtZkKgHXm7f29F+KBi/lk=";
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
