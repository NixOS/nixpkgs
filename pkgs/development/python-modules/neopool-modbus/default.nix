{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  pymodbus,
  pytest-asyncio,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage (finalAttrs: {
  pname = "neopool-modbus";
  version = "4.9.0";
  pyproject = true;

  disabled = pythonOlder "3.13";

  src = fetchFromGitHub {
    owner = "svasek";
    repo = "python-neopool-modbus";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ns7ZyoX+YqssfQ8FFX0j8WTjjXi1EDDK9EVJGxW3LEM=";
  };

  build-system = [ hatchling ];

  dependencies = [ pymodbus ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "neopool_modbus" ];

  meta = {
    description = "Async Python client for Sugar Valley NeoPool / VistaPool / Hidrolife Modbus pool controllers";
    homepage = "https://github.com/svasek/python-neopool-modbus";
    changelog = "https://github.com/svasek/python-neopool-modbus/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
})
