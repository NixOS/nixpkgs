{
  lib,
  aiohttp,
  buildPythonPackage,
  dacite,
  fetchFromGitHub,
  hatchling,
  pytest-asyncio,
  pytestCheckHook,
  typing-extensions,
  uv-dynamic-versioning,
}:

buildPythonPackage (finalAttrs: {
  pname = "pyintelliclima";
  version = "0.5.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "dvdinth";
    repo = "pyintelliclima";
    tag = "v${finalAttrs.version}";
    hash = "sha256-CPGu1fq8CBlitQOVaUir2lrBijpOXQ6dx7SekQJATWk=";
  };

  build-system = [
    hatchling
    uv-dynamic-versioning
  ];

  dependencies = [
    aiohttp
    dacite
    typing-extensions
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
