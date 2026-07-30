{
  lib,
  bleak,
  bleak-retry-connector,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "automower-ble";
  version = "0.2.9";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "alistair23";
    repo = "AutoMower-BLE";
    tag = finalAttrs.version;
    hash = "sha256-3Hiplg4PTu84H890JwTja7wopB7bSYteGXR7RQ/J++0=";
  };

  build-system = [ setuptools ];

  dependencies = [
    bleak
    bleak-retry-connector
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "automower_ble" ];

  meta = {
    description = "Module to connect to Husqvarna Automower Connect";
    homepage = "https://github.com/alistair23/AutoMower-BLE";
    changelog = "https://github.com/alistair23/AutoMower-BLE/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ fab ];
  };
})
