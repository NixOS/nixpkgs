{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  pytest-asyncio,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "autoskope-client";
  version = "1.4.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mcisk";
    repo = "autoskope_client";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ThrI5BzjxVg4K1fvRZvPfDycAh4A9rm226FSpk3a/zs=";
  };

  build-system = [ setuptools ];

  dependencies = [ aiohttp ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  disabledTestMarks = [
    "integration"
  ];

  pythonImportsCheck = [ "autoskope_client" ];

  meta = {
    description = "Python client library for the Autoskope API";
    homepage = "https://github.com/mcisk/autoskope_client";
    changelog = "https://github.com/mcisk/autoskope_client/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ jamiemagee ];
  };
})
