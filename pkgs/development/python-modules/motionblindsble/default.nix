{
  lib,
  bleak-retry-connector,
  bleak,
  buildPythonPackage,
  fetchFromGitHub,
  pycryptodome,
  pytest-asyncio,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "motionblindsble";
  version = "0.1.2";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "LennP";
    repo = "motionblindsble";
    rev = "refs/tags/${version}";
    hash = "sha256-MBO8tiGTd5qF7zGp+RkkV8nJHP9TJvk3LdWsZqlsl50=";
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

  meta = with lib; {
    description = "Module to interface with Motionblinds motors using Bluetooth Low Energy (BLE)";
    homepage = "https://github.com/LennP/motionblindsble";
    changelog = "https://github.com/LennP/motionblindsble/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
