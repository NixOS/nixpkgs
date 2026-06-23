{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytest,
  pytest-asyncio,
  pytest-cov,
  pytest-timeout,
  pytestCheckHook,
  rns,
  bleak,
  bluezero,
  dbus-fast,
  dbus-python,
  nix-update-script,
}:

buildPythonPackage (finalAttrs: {
  pname = "ble-reticulum";
  version = "0.2.2-unstable-2026-01-18";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "torlando-tech";
    repo = "ble-reticulum";
    rev = "07d941304c9a1dc3a8e58087b3b974ff3d229e56";
    hash = "sha256-qtNn2OEcBbjAJprHDRBE4f8HyOavr5mzQrtMkxh1oxE=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    bleak
    bluezero
    dbus-fast
    dbus-python
  ];

  pythonImportsCheck = [
    "ble_reticulum"
  ];

  doCheck = true;
  nativeCheckInputs = [
    rns
    pytestCheckHook
    pytest
    pytest-asyncio
    pytest-cov
    pytest-timeout
  ];

  disabledTestPaths = [
    # AttributeError: 'NoneType' object has no attribute '_default_ic_max_held_announces'
    "tests/test_v2_2_identity_handshake.py"
    "tests/test_v2_2_mac_sorting.py"
    "tests/test_v2_2_race_conditions.py"
    "tests/test_zombie_connection_detection.py"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "BLE Interface for Reticulum Network";
    homepage = "https://github.com/torlando-tech/ble-reticulum";
    changelog = "https://github.com/torlando-tech/ble-reticulum/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ drupol ];
  };
})
