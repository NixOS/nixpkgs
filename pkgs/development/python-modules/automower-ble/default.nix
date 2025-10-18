{
  lib,
  bleak,
  bleak-retry-connector,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "automower-ble";
  version = "0.2.8";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "alistair23";
    repo = "AutoMower-BLE";
    tag = version;
    hash = "sha256-GawjNtk2mEBo9Xe1k1z0tk1RWU0N0JddeC6NZbnLpxc=";
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
    changelog = "https://github.com/alistair23/AutoMower-BLE/releases/tag/${src.tag}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ fab ];
  };
}
