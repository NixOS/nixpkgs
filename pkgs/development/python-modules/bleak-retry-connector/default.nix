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
  pythonOlder,
  stdenv,
}:

buildPythonPackage rec {
  pname = "bleak-retry-connector";
  version = "4.4.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Bluetooth-Devices";
    repo = "bleak-retry-connector";
    tag = "v${version}";
    hash = "sha256-T7mJUj/AF+ZuTiGGFHUT7Ftnz+A0O5nGjj4a75obsuc=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    bleak
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
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
    changelog = "https://github.com/Bluetooth-Devices/bleak-retry-connector/releases/tag/${src.tag}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
