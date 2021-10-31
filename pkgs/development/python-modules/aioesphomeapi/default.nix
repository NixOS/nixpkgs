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
  version = "10.2.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "esphome";
    repo = pname;
    rev = "v${version}";
    sha256 = "00dpjcwn9zqld2ggl9hrb4vnqgmi1hn2wg6w03b74gx6p8zkshs9";
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
