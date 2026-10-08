{
  bluetooth-data-tools,
  buildPythonPackage,
  cython,
  fetchFromGitHub,
  habluetooth,
  lib,
  poetry-core,
  pysmlight,
  pytest-asyncio,
  pytest-codspeed,
  pytest-cov-stub,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "bleak-smlight";
  version = "1.1.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "bluetooth-devices";
    repo = "bleak-smlight";
    tag = "v${finalAttrs.version}";
    hash = "sha256-U98TZup4JV4D+g3YuVXyoUWTUjspGRymUiMasrT7ang=";
  };

  build-system = [
    cython
    poetry-core
    setuptools
  ];

  dependencies = [
    bluetooth-data-tools
    habluetooth
    pysmlight
  ];

  pythonImportsCheck = [ "bleak_smlight" ];

  nativeCheckInputs = [
    pytest-asyncio
    pytest-codspeed
    pytest-cov-stub
    pytestCheckHook
  ];

  meta = {
    changelog = "https://github.com/bluetooth-devices/bleak-smlight/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    description = "Bleak backend for SMLIGHT SLZB Bluetooth proxies";
    homepage = "https://github.com/bluetooth-devices/bleak-smlight";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.dotlambda ];
  };
})
