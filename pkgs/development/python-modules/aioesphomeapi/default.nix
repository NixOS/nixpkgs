{ lib
, buildPythonPackage
, fetchFromGitHub
, mock
, protobuf
, pytest-asyncio
, pytestCheckHook
, pythonOlder
, zeroconf
}:

buildPythonPackage rec {
  pname = "aioesphomeapi";
  version = "6.1.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "esphome";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-C799JoW58mmwHeoXLMJ5pYg8hjaZqVBqrbxBXpmF/mQ=";
  };

  propagatedBuildInputs = [
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
