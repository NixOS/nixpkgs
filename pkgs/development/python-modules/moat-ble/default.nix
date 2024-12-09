{
  lib,
  bluetooth-sensor-state-data,
  buildPythonPackage,
  fetchFromGitHub,
  home-assistant-bluetooth,
  poetry-core,
  pytestCheckHook,
  pythonOlder,
  sensor-state-data,
}:

buildPythonPackage rec {
  pname = "moat-ble";
  version = "0.1.1";
  format = "pyproject";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "Bluetooth-Devices";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-dy1Fm0Z1PUsPY8QTiXUcWSi+csFnTUsobSkA92m06QI=";
  };

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [
    bluetooth-sensor-state-data
    home-assistant-bluetooth
    sensor-state-data
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace " --cov=moat_ble --cov-report=term-missing:skip-covered" ""
  '';

  pythonImportsCheck = [ "moat_ble" ];

  meta = with lib; {
    description = "Library for Moat BLE devices";
    homepage = "https://github.com/Bluetooth-Devices/moat-ble";
    changelog = "https://github.com/Bluetooth-Devices/moat-ble/releases/tag/v${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
