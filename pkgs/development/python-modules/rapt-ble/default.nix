{ lib
, bluetooth-data-tools
, bluetooth-sensor-state-data
, buildPythonPackage
, fetchFromGitHub
, home-assistant-bluetooth
, poetry-core
, pytestCheckHook
, pythonOlder
, sensor-state-data
}:

buildPythonPackage rec {
  pname = "rapt-ble";
  version = "0.1.0";
  format = "pyproject";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "sairon";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-upTtVqxVHrqLSGTSGCiCVlDa2NEuuqe+0W2DM+UhTnc=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace " --cov=rapt_ble --cov-report=term-missing:skip-covered" ""
  '';

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    bluetooth-data-tools
    bluetooth-sensor-state-data
    home-assistant-bluetooth
    sensor-state-data
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "rapt_ble"
  ];

  meta = with lib; {
    description = "Library for RAPT Pill hydrometer BLE devices";
    homepage = "https://github.com/sairon/rapt-ble";
    changelog = "https://github.com/sairon/rapt-ble/blob/v${version}/CHANGELOG.md";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
