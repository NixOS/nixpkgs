{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  pythonOlder,
  pytest-asyncio,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "pyforeca";
  version = "0.4.0";
  pyproject = true;

  disabled = pythonOlder "3.12";

  src = fetchFromGitHub {
    owner = "foreca-dev";
    repo = "pyforeca";
    tag = "v${finalAttrs.version}";
    hash = "sha256-hqtBfg92u0yxhT24R1KehsF0GL2YFzvTgpRtsXUeJv0=";
  };

  build-system = [ hatchling ];

  dependencies = [ aiohttp ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "pyforeca" ];

  meta = {
    description = "Async Python client for the Foreca Weather API";
    homepage = "https://github.com/foreca-dev/pyforeca";
    changelog = "https://github.com/foreca-dev/pyforeca/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
})
