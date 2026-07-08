{
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  lib,
  pymodbus,
  pyprojectVersionPatchHook,
  pytest-asyncio,
  pytestCheckHook,
  tmodbus,
}:

buildPythonPackage (finalAttrs: {
  pname = "modbus-connection";
  version = "3.3.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "home-assistant-libs";
    repo = "modbus-connection";
    tag = finalAttrs.version;
    hash = "sha256-IEdOLd+BjX2b6bQS7hw33CyuDFVJ5dO0BaHLLhGp3LE=";
  };

  nativeBuildInputs = [
    pyprojectVersionPatchHook
  ];

  build-system = [
    hatchling
  ];

  optional-dependencies = {
    pymodbus = [
      pymodbus
    ]
    ++ pymodbus.optional-dependencies.serial;
    tmodbus = [
      tmodbus
    ]
    ++ tmodbus.optional-dependencies.async-serial
    ++ tmodbus.optional-dependencies.smart;
  };

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ]
  ++ lib.concatAttrValues finalAttrs.passthru.optional-dependencies;

  pythonImportsCheck = [
    "modbus_connection"
  ];

  meta = {
    description = "Small, backend-neutral Modbus connection abstraction";
    homepage = "https://github.com/home-assistant-libs/modbus-connection";
    changelog = "https://github.com/home-assistant-libs/modbus-connection/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ hexa ];
  };
})
