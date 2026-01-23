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

buildPythonPackage rec {
  pname = "motionblindsble";
  version = "0.1.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "LennP";
    repo = "motionblindsble";
    tag = version;
    hash = "sha256-1dA3YTjoAhe+p5vk6Xb42a+rE63m2mn5iHhVV/6tlQ0=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail "{{VERSION_PLACEHOLDER}}" "${version}"
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
    changelog = "https://github.com/LennP/motionblindsble/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
