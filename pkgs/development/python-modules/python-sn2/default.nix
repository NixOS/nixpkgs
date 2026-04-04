{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pytest-asyncio,
  setuptools,
  websockets,
}:

buildPythonPackage (finalAttrs: {
  pname = "python-sn2";
  version = "0.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "konsulten";
    repo = "python-sn2";
    tag = "v${finalAttrs.version}";
    hash = "sha256-7IrfTjww2K64qIQ6dGMcTja1/dV5/wt+pcx6ZLW9KEA=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    websockets
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-asyncio
  ];

  pythonImportsCheck = [ "sn2" ];

  meta = {
    description = "Python library for SystemNexa2 device integration";
    homepage = "https://github.com/konsulten/python-sn2";
    changelog = "https://github.com/konsulten/python-sn2/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
})
