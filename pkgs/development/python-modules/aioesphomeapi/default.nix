{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, protobuf
, zeroconf
}:

buildPythonPackage rec {
  pname = "aioesphomeapi";
  version = "5.0.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-2IxXhAysQiqqEd4Mfjgc5vX0+D60rof2nPJDXy9tRVs=";
  };

  propagatedBuildInputs = [
    protobuf
    zeroconf
  ];

  # no tests implemented
  doCheck = false;

  pythonImportsCheck = [
    "aioesphomeapi"
  ];

  meta = with lib; {
    description = "Python Client for ESPHome native API";
    homepage = "https://github.com/esphome/aioesphomeapi";
    license = licenses.mit;
    maintainers = with maintainers; [ fab hexa ];
  };
}
