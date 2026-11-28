{
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  lib,
  modbus-connection,
  pyprojectVersionPatchHook,
  pytest-asyncio,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "aerosmart-modbus";
  version = "0.3.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "kayloehmann";
    repo = "aerosmart-modbus";
    tag = finalAttrs.version;
    hash = "sha256-LSBkEnH22llPmUO7UNrAFdoLDNmivneRd1SpvfQAFzU=";
  };

  nativeBuildInputs = [
    pyprojectVersionPatchHook
  ];

  build-system = [
    hatchling
  ];

  dependencies = [
    modbus-connection
  ];

  optional-dependencies.cli = modbus-connection.optional-dependencies.pymodbus;

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "aerosmart_modbus"
  ];

  meta = {
    description = "Typed Modbus device model for aerosmart ventilation and heat-pump units";
    homepage = "https://github.com/kayloehmann/aerosmart-modbus";
    changelog = "https://github.com/kayloehmann/aerosmart-modbus/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
})
