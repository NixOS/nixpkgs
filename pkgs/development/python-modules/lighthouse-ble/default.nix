{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  hatchling,
  bleak,
  bleak-retry-connector,
  pytest-asyncio,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "lighthouse-ble";
  version = "0.2.0";
  pyproject = true;

  disabled = pythonOlder "3.13";

  src = fetchFromGitHub {
    owner = "g4bri3lDev";
    repo = "lighthouse-ble";
    tag = "v${finalAttrs.version}";
    hash = "sha256-GnzYyrM25ycb66u+c+YK1DAVnMvip8MIG4lAFRfrTpc=";
  };

  build-system = [ hatchling ];

  dependencies = [
    bleak
    bleak-retry-connector
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "lighthouse_ble" ];

  meta = {
    description = "Async Bluetooth LE control of SteamVR Lighthouse base stations (Valve Index V2, HTC Vive V1)";
    homepage = "https://github.com/g4bri3lDev/lighthouse-ble";
    changelog = "https://github.com/g4bri3lDev/lighthouse-ble/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.jamiemagee ];
    mainProgram = "lighthouse-ble";
  };
})
