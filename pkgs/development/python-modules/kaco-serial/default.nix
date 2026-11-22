{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  pytest-asyncio,
  pytestCheckHook,
  pythonOlder,
  serialx,
}:

buildPythonPackage (finalAttrs: {
  pname = "kaco-serial";
  version = "1.0.3";
  pyproject = true;

  disabled = pythonOlder "3.13";

  src = fetchFromGitHub {
    owner = "g4bri3lDev";
    repo = "kaco-rs485";
    tag = "v${finalAttrs.version}";
    hash = "sha256-cNe68p2xiL3ZRpvfdA+RQCZL+fqYpAWp8XiRuUZ3ciY=";
  };

  build-system = [ hatchling ];

  dependencies = [ serialx ];

  optional-dependencies.cli = serialx.optional-dependencies.esphome;

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "kaco_rs485" ];

  meta = {
    description = "Read KACO Powador xi-series inverters over RS485, locally or via an ESPHome serial proxy";
    homepage = "https://github.com/g4bri3lDev/kaco-rs485";
    changelog = "https://github.com/g4bri3lDev/kaco-rs485/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.jamiemagee ];
    mainProgram = "kaco-rs485";
  };
})
