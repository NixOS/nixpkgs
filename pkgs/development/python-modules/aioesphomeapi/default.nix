{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, protobuf
, zeroconf
}:

buildPythonPackage rec {
  pname = "aioesphomeapi";
  version = "4.1.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0210l2d5g76pllr2vh990k9shfv3zrknx5d2dmgqb5y90142cp76";
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
