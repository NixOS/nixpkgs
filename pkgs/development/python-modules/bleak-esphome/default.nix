{ lib
, aioesphomeapi
, bleak
, bluetooth-data-tools
, buildPythonPackage
, fetchFromGitHub
, habluetooth
, lru-dict
, poetry-core
, pytest-asyncio
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "bleak-esphome";
  version = "0.4.1";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "bluetooth-devices";
    repo = "bleak-esphome";
    rev = "refs/tags/v${version}";
    hash = "sha256-cLjQg54DL17VtM/NFOQUE0dJThz5EhjipW2t9yhAMQ0=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace " --cov=bleak_esphome --cov-report=term-missing:skip-covered" ""
  '';

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    aioesphomeapi
    bleak
    bluetooth-data-tools
    habluetooth
    lru-dict
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "bleak_esphome"
  ];

  meta = with lib; {
    description = "Bleak backend of ESPHome";
    homepage = "https://github.com/bluetooth-devices/bleak-esphome";
    changelog = "https://github.com/bluetooth-devices/bleak-esphome/blob/${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
