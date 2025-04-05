{
  lib,
  aioesphomeapi,
  bleak,
  bleak-retry-connector,
  bluetooth-data-tools,
  buildPythonPackage,
  cython,
  fetchFromGitHub,
  habluetooth,
  lru-dict,
  poetry-core,
  pytest-asyncio,
  pytest-codspeed,
  pytest-cov-stub,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "bleak-esphome";
  version = "2.13.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "bluetooth-devices";
    repo = "bleak-esphome";
    tag = "v${version}";
    hash = "sha256-ziUSqIox5tWp64EJ+Hacy1Wbh8NMpH/GUY9TUaN7Y3M=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "setuptools>=75.8.2" setuptools
  '';

  build-system = [
    cython
    poetry-core
    setuptools
  ];

  dependencies = [
    aioesphomeapi
    bleak
    bleak-retry-connector
    bluetooth-data-tools
    habluetooth
    lru-dict
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytest-codspeed
    pytest-cov-stub
    pytestCheckHook
  ];

  pythonImportsCheck = [ "bleak_esphome" ];

  meta = with lib; {
    description = "Bleak backend of ESPHome";
    homepage = "https://github.com/bluetooth-devices/bleak-esphome";
    changelog = "https://github.com/bluetooth-devices/bleak-esphome/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
