{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatch-vcs,
  hatchling,
  modbus-connection,
  pytest-asyncio,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "fronius-modbus";
  version = "0.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "farmio";
    repo = "fronius-modbus";
    tag = finalAttrs.version;
    hash = "sha256-P7zTFB3xpuJ7oEQqwd/Vbn+Kush5eVjpYPlgZO8O9vE=";
  };

  build-system = [
    hatch-vcs
    hatchling
  ];

  dependencies = [
    modbus-connection
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "fronius_modbus" ];

  meta = {
    description = "Library for Fronius inverter Modbus TCP (SunSpec) interfaces, built on modbus-connection";
    homepage = "https://github.com/farmio/fronius-modbus";
    changelog = "https://github.com/farmio/fronius-modbus/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl3Plus;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
})
