{
  lib,
  bleak-retry-connector,
  bleak,
  buildPythonPackage,
  fetchFromGitHub,
  pycryptodome,
  pytest-asyncio,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "motionblindsble";
  version = "0.1.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "LennP";
    repo = "motionblindsble";
    tag = finalAttrs.version;
    hash = "sha256-UG8+hId743z3UIR6DcWuEgQCbKaY5CD+Bw8mqIeWscY=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail "{{VERSION_PLACEHOLDER}}" "${finalAttrs.version}"
  '';

  build-system = [ setuptools ];

  dependencies = [
    bleak
    bleak-retry-connector
    pycryptodome
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "motionblindsble" ];

  disabledTests = [
    # AssertionError
    "test_establish_connection"
  ];

  meta = {
    description = "Module to interface with Motionblinds motors using Bluetooth Low Energy (BLE)";
    homepage = "https://github.com/LennP/motionblindsble";
    changelog = "https://github.com/LennP/motionblindsble/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
