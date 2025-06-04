{
  lib,
  bleak,
  bleak-retry-connector,
  buildPythonPackage,
  cryptography,
  fetchPypi,
  poetry-core,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "eufylife-ble-client";
  version = "0.1.10";
  format = "pyproject";

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    pname = "eufylife_ble_client";
    inherit version;
    hash = "sha256-hfUsFifkwr5qhYM6Otlxo4AAGu967p/eWCR+yBrC4eM=";
  };

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [
    bleak
    bleak-retry-connector
    cryptography
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "eufylife_ble_client" ];

  meta = with lib; {
    description = "Module for parsing data from Eufy smart scales";
    homepage = "https://github.com/bdr99/eufylife-ble-client";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
