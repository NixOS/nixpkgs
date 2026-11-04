{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  modbus-connection,
  pytest-asyncio,
  pytest-cov-stub,
  pytestCheckHook,
  rich,
}:

buildPythonPackage (finalAttrs: {
  pname = "kaco-modbus";
  version = "2.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "g4bri3lDev";
    repo = "kaco-modbus";
    tag = "v${finalAttrs.version}";
    hash = "sha256-zGGz5bIDv4F5TkdczwgSv8Ah4nuZpZ5mXjXFTCEsLDA=";
  };

  build-system = [ hatchling ];

  dependencies = [ modbus-connection ];

  optional-dependencies.cli = [
    rich
  ]
  ++ modbus-connection.optional-dependencies.tmodbus;

  nativeCheckInputs = [
    pytest-asyncio
    pytest-cov-stub
    pytestCheckHook
  ]
  ++ finalAttrs.passthru.optional-dependencies.cli;

  pythonImportsCheck = [ "kaco_modbus" ];

  meta = {
    description = "Read and control KACO solar inverters over SunSpec Modbus";
    homepage = "https://github.com/g4bri3lDev/kaco-modbus";
    changelog = "https://github.com/g4bri3lDev/kaco-modbus/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
})
