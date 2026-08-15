{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  bleak,
  bleak-retry-connector,
  cryptography,
  epaper-dithering,
  nrf-ota,
  numpy,
  pillow,
  pytestCheckHook,
  pytest-asyncio,
  silabs-ble-ota,
  rich,
  zeroconf,
}:

buildPythonPackage (finalAttrs: {
  pname = "py-opendisplay";
  version = "7.16.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "OpenDisplay";
    repo = "py-opendisplay";
    tag = "v${finalAttrs.version}";
    hash = "sha256-92b1Xp/rzH6XqnWz+z6/B0YUHCt8F8qIax4ECyR6PzA=";
  };

  build-system = [ hatchling ];

  dependencies = [
    bleak
    bleak-retry-connector
    cryptography
    epaper-dithering
    numpy
    pillow
  ];

  optional-dependencies = {
    cli = [ rich ];
    wifi = [ zeroconf ];
    nrf-ota = [ nrf-ota ];
    silabs-ota = [ silabs-ble-ota ];
  };

  pythonRelaxDeps = [ "epaper-dithering" ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-asyncio
  ]
  ++ lib.concatAttrValues finalAttrs.passthru.optional-dependencies;

  pythonImportsCheck = [ "opendisplay" ];

  meta = {
    description = "Python library for communicating with OpenDisplay BLE e-paper displays";
    homepage = "https://github.com/OpenDisplay/py-opendisplay";
    changelog = "https://github.com/OpenDisplay/py-opendisplay/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
})
