{ lib
, bluetooth-sensor-state-data
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, pycryptodomex
, pytestCheckHook
, pythonOlder
, sensor-state-data
}:

buildPythonPackage rec {
  pname = "atc-ble";
  version = "0.1.0";
  format = "pyproject";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "Bluetooth-Devices";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-rwOFKxUlbbNIDJRdCmZpHstXwxcTnvlExgcVDdGbIVY=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    bluetooth-sensor-state-data
    pycryptodomex
    sensor-state-data
  ];

  checkInputs = [
    pytestCheckHook
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace " --cov=atc_ble --cov-report=term-missing:skip-covered" ""
  '';

  pythonImportsCheck = [
    "atc_ble"
  ];

  meta = with lib; {
    description = "Library for ATC devices with custom firmware";
    homepage = "https://github.com/Bluetooth-Devices/atc-ble";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
