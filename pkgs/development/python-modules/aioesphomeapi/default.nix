{ lib
, buildPythonPackage
, fetchFromGitHub
, async-timeout
, chacha20poly1305-reuseable
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
  version = "15.1.15";
  format = "setuptools";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "esphome";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-qNljw3V0rfMb6GDtTd+jy/hHBaM3kc9y+RCEoNTKHFM=";
  };

  propagatedBuildInputs = [
    async-timeout
    chacha20poly1305-reuseable
    noiseprotocol
    protobuf
    zeroconf
  ];

  nativeCheckInputs = [
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
    changelog = "https://github.com/esphome/aioesphomeapi/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab hexa ];
  };
}
