{
  lib,
  bleak,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "automower-ble";
  version = "0.2.1";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "alistair23";
    repo = "AutoMower-BLE";
    tag = version;
    hash = "sha256-k0cVjpuhPFpPoPVFj0uoKVoFEQn4TNIuFLedJfawlaA=";
  };

  build-system = [ setuptools ];

  dependencies = [ bleak ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "automower_ble" ];

  meta = {
    description = "Module to connect to Husqvarna Automower Connect";
    homepage = "https://github.com/alistair23/AutoMower-BLE";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ fab ];
  };
}
