{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  bleak,
  bleak-retry-connector,
  cryptography,
  pyprojectVersionPatchHook,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "pyflic-ble";
  version = "0.2.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "50ButtonsEach";
    repo = "pyflic-ble";
    tag = "v${finalAttrs.version}";
    hash = "sha256-AMQ0vSGCl7d/unYSK6y+Xn6ZfYaKXU+dKD0yipvWyF4=";
  };

  # The release tag contains stale version metadata.
  nativeBuildInputs = [ pyprojectVersionPatchHook ];

  build-system = [ setuptools ];

  dependencies = [
    bleak
    bleak-retry-connector
    cryptography
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pyflic_ble" ];

  meta = {
    description = "Python library for Flic smart button BLE communication";
    homepage = "https://github.com/50ButtonsEach/pyflic-ble";
    changelog = "https://github.com/50ButtonsEach/pyflic-ble/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
})
