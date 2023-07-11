{ lib
, bleak
, bleak-retry-connector
, buildPythonPackage
, cryptography
, fetchPypi
, poetry-core
, pythonOlder
}:

buildPythonPackage rec {
  pname = "eufylife-ble-client";
  version = "0.1.7";
  format = "pyproject";

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    pname = "eufylife_ble_client";
    inherit version;
    hash = "sha256-Vt9hHUVAM0d+BcotPUD9v8jXrcg7lEDVChLENUHd3rY=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    bleak
    bleak-retry-connector
    cryptography
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [
    "eufylife_ble_client"
  ];

  meta = with lib; {
    description = "Module for parsing data from Eufy smart scales";
    homepage = "https://github.com/bdr99/eufylife-ble-client";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
