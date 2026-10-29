{
  lib,
  aiohttp,
  buildPythonPackage,
  dacite,
  fetchFromGitHub,
  hatchling,
  pytest-asyncio,
  pytestCheckHook,
  uv-dynamic-versioning,
}:

buildPythonPackage (finalAttrs: {
  pname = "pyintelliclima";
  version = "0.3.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "dvdinth";
    repo = "pyintelliclima";
    tag = "v${finalAttrs.version}";
    hash = "sha256-EHcnrynvNIfo31vZyh8tS/5JfFuEQGVlYzu4XyD3XCI=";
  };

  pythonRelaxDeps = [ "dacite" ];

  build-system = [
    hatchling
    uv-dynamic-versioning
  ];

  dependencies = [
    aiohttp
    dacite
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "pyintelliclima" ];

  meta = {
    description = "Python module for a HTTP API to communicate with the IntelliClima device server";
    homepage = "https://github.com/dvdinth/pyintelliclima";
    changelog = "https://github.com/dvdinth/pyintelliclima/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
})
