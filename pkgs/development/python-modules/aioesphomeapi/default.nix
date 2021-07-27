{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, protobuf
, zeroconf
}:

buildPythonPackage rec {
  pname = "aioesphomeapi";
  version = "5.1.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "04r97d8bc5amvjvf2sxy2h4jf6z348q6p5z1nsxfnif80kxl0k60";
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
