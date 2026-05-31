{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  bleak,
  bleak-retry-connector,
  cryptography,
  epaper-dithering,
  numpy,
  pillow,
  pytestCheckHook,
  pytest-asyncio,
}:

buildPythonPackage (finalAttrs: {
  pname = "py-opendisplay";
  version = "5.9.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "OpenDisplay";
    repo = "py-opendisplay";
    tag = "v${finalAttrs.version}";
    hash = "sha256-7YR+VPCsmuDJaWdToCytg8zsIDkKVRiQnVlmWtBzqrA=";
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

  nativeCheckInputs = [
    pytestCheckHook
    pytest-asyncio
  ];

  pythonImportsCheck = [ "opendisplay" ];

  meta = {
    description = "Python library for communicating with OpenDisplay BLE e-paper displays";
    homepage = "https://github.com/OpenDisplay/py-opendisplay";
    changelog = "https://github.com/OpenDisplay/py-opendisplay/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
})
