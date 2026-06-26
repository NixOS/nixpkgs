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
  version = "0.2.4";
  pyproject = true;

  disabled = pythonOlder "3.13";

  src = fetchFromGitHub {
    owner = "SukramJ";
    repo = "pydevccu";
    tag = finalAttrs.version;
    hash = "sha256-/Z1+k9CNTQsqTXSIqmUQn7r5WBTgZmqsg5Z+cq9nR3Q=";
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
