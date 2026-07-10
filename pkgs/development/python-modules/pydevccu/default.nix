{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  orjson,
  pytest-asyncio,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "pydevccu";
  version = "0.2.5";
  pyproject = true;

  disabled = pythonOlder "3.13";

  src = fetchFromGitHub {
    owner = "SukramJ";
    repo = "pydevccu";
    tag = finalAttrs.version;
    hash = "sha256-Sf8XBvkf6dRuA6daJ48WJHuVYBhznDcPWLl+4xm46n0=";
  };

  build-system = [ setuptools ];

  dependencies = [ aiohttp ];

  optional-dependencies = {
    fast = [ orjson ];
  };

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "pydevccu" ];

  meta = {
    description = "HomeMatic CCU XML-RPC Server with fake devices";
    homepage = "https://github.com/SukramJ/pydevccu";
    changelog = "https://github.com/SukramJ/pydevccu/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
