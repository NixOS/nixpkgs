{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  bluetooth-data-tools,
  bluetooth-sensor-state-data,
  home-assistant-bluetooth,
  sensor-state-data,
  pytest-cov-stub,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "chefiq-ble";
  version = "1.1.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Invader444";
    repo = "chefiq-ble";
    tag = "v${finalAttrs.version}";
    hash = "sha256-4zxEUtcsi91lgRU6WFnPMaGR5hjUWHXZyInP3MIoqEo=";
  };

  build-system = [ hatchling ];

  dependencies = [
    bluetooth-data-tools
    bluetooth-sensor-state-data
    home-assistant-bluetooth
    sensor-state-data
  ];

  nativeCheckInputs = [
    pytest-cov-stub
    pytestCheckHook
  ];

  pythonImportsCheck = [ "chefiq_ble" ];

  meta = {
    description = "Passive BLE advertisement parser for Chef iQ wireless probes (CQ50/CQ60)";
    homepage = "https://github.com/Invader444/chefiq-ble";
    changelog = "https://github.com/Invader444/chefiq-ble/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
})
