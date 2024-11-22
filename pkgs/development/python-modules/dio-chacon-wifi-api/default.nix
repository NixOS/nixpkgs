{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  poetry-core,

  # dependencies
  aiohttp,

  # tests
  aioresponses,
  pytest-aiohttp,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "dio-chacon-wifi-api";
  version = "1.2.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "cnico";
    repo = "dio-chacon-wifi-api";
    rev = "refs/tags/v${version}";
    hash = "sha256-4qE4laKQyfnAq2f/bkAqIfY/LnEmW+LTvNOCkTNFbAo=";
  };

  build-system = [ poetry-core ];

  dependencies = [ aiohttp ];

  nativeCheckInputs = [
    aioresponses
    pytest-aiohttp
    pytestCheckHook
  ];

  pythonImportsCheck = [ "dio_chacon_wifi_api" ];

  meta = with lib; {
    description = "Python API via wifi for DIO devices from Chacon. Useful for homeassistant or other automations";
    homepage = "https://github.com/cnico/dio-chacon-wifi-api";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ hexa ];
  };
}
