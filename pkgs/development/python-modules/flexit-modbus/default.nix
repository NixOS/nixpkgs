{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  modbus-connection,
  pytest-asyncio,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "flexit-modbus";
  version = "0.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "troelde";
    repo = "flexit-modbus";
    tag = finalAttrs.version;
    hash = "sha256-/Cbqpd/hWGnX1nqG0tZn/BtM9V0xXFCZw3EcqiYO1fc=";
  };

  build-system = [ hatchling ];

  dependencies = [ modbus-connection ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "flexit_modbus" ];

  meta = {
    description = "Read and control a Flexit air handling unit with a CI66 Modbus adapter";
    homepage = "https://github.com/troelde/flexit-modbus";
    changelog = "https://github.com/troelde/flexit-modbus/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
})
