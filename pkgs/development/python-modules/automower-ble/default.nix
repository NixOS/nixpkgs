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
  version = "0.2.0";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "alistair23";
    repo = "AutoMower-BLE";
    tag = version;
    hash = "sha256-BWfRXz78e1Xq0fNOGJ2IFnjNqfH3oD5VIGMxyCPtEUw=";
  };

  build-system = [ setuptools ];

  dependencies = [ bleak ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "automower_ble" ];

  meta = with lib; {
    description = "Module to connect to Husqvarna Automower Connect";
    homepage = "https://github.com/alistair23/AutoMower-BLE";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ fab ];
  };
}
