{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  modbus-connection,
  probatio,
  pyprojectVersionPatchHook,
  pytest-asyncio,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "bluetti-modbus";
  version = "0.52.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "bluetti-community";
    repo = "bluetti-modbus";
    tag = finalAttrs.version;
    hash = "sha256-A8A9LsqFcVRav1ANXVDuaOB0R15vn+ADexR+cwuTt2c=";
  };

  nativeBuildInputs = [ pyprojectVersionPatchHook ];

  build-system = [ setuptools ];

  dependencies = [
    modbus-connection
    probatio
  ];

  optional-dependencies = {
    cli = modbus-connection.optional-dependencies.tmodbus;
    cli-pymodbus = modbus-connection.optional-dependencies.pymodbus;
  };

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ]
  ++ lib.concatAttrValues finalAttrs.passthru.optional-dependencies;

  pythonImportsCheck = [ "bluetti_modbus_lib" ];

  meta = {
    description = "Unofficial library for basic communication to BLUETTI Power Stations via Modbus";
    homepage = "https://github.com/bluetti-community/bluetti-modbus";
    changelog = "https://github.com/bluetti-community/bluetti-modbus/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
})
