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
  version = "13.9.0";
  format = "setuptools";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "esphome";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-RjLzOl8Cb6Vrq+75SvBntAmmiK70i3o2rED7Smnpiws=";
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
