{
  buildPythonPackage,
  fetchFromGitHub,
  gitMinimal,
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
  version = "4.10.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "home-assistant-libs";
    repo = "modbus-connection";
    tag = finalAttrs.version;
    hash = "sha256-7k1JRIbxgN8EGbs6j0BxQiiqiBBq3s3OLUjJ7smd5hc=";
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
    ++ tmodbus.optional-dependencies.async-serial;
  };

  nativeCheckInputs = [
    gitMinimal
    pytest-asyncio
    pytestCheckHook
  ]
  ++ lib.concatAttrValues finalAttrs.passthru.optional-dependencies;

  disabledTests = [
    # tries to git clone https://github.com/sunspec/models
    "test_official_model_catalogue_generates_and_imports"
  ];

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
