{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  bleak,
  mypy,
  ruff,
  pytestCheckHook,
  pytest-asyncio,
  pytest-cov-stub,
  nix-update-script,
}:

buildPythonPackage (finalAttrs: {
  pname = "nrf-ota";
  version = "0.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "OpenDisplay";
    repo = "nrf-ota";
    tag = "v${finalAttrs.version}";
    hash = "sha256-l7mcwf0HZfzcTVitGwzEnD+RxC5/ujAsOgGyQFZZprE=";
  };

  build-system = [
    hatchling
  ];

  dependencies = [
    bleak
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-cov-stub
    pytest-asyncio
  ];

  pythonImportsCheck = [
    "nrf_ota"
  ];

  __structuredAttrs = true;

  meta = {
    description = "Flash firmware to Nordic nRF5x devices over BLE";
    homepage = "https://github.com/OpenDisplay/nrf-ota";
    changelog = "https://github.com/OpenDisplay/nrf-ota/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ hexa ];
  };
})
