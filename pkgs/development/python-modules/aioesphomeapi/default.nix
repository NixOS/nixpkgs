{ lib
, buildPythonPackage
, fetchFromGitHub
, mock
, noiseprotocol
, protobuf
, pytest-asyncio
, pytestCheckHook
, pythonOlder
, zeroconf
}:

buildPythonPackage rec {
  pname = "aioesphomeapi";
  version = "10.8.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "esphome";
    repo = pname;
    rev = "v${version}";
    sha256 = "1hi312gvkrmcxhrc8s3zxwbh87hakd42k5hk7c3xqilc4in3d5dv";
  };

  propagatedBuildInputs = [
    noiseprotocol
    protobuf
    zeroconf
  ];

  checkInputs = [
    mock
    pytest-asyncio
    pytestCheckHook
  ];

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
