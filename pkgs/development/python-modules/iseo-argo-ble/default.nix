{
  lib,
  bleak,
  buildPythonPackage,
  cryptography,
  fetchFromGitHub,
  hatchling,
  pytest-asyncio,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "iseo-argo-ble";
  version = "0.9.10";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "FezVrasta";
    repo = "iseo-argo-ble";
    tag = "v${finalAttrs.version}";
    hash = "sha256-beRrJStezm9TKv1zs0VBVd4vDvkxH70N+K+Gp1T8++k=";
  };

  build-system = [ hatchling ];

  dependencies = [
    bleak
    cryptography
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "iseo_argo_ble" ];

  meta = {
    description = "ISEO Argo BLE Lock protocol library";
    homepage = "https://github.com/FezVrasta/iseo-argo-ble";
    changelog = "https://github.com/FezVrasta/iseo-argo-ble/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
})
