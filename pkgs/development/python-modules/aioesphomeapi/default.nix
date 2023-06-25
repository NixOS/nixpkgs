{ lib
, buildPythonPackage
, fetchFromGitHub
, async-timeout
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
  version = "14.1.1";
  format = "setuptools";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "esphome";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-v91nIMO4Ctp7csx/sHw16SF02dp9kV//kpjRJP5/mu4=";
  };

  propagatedBuildInputs = [
    async-timeout
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
