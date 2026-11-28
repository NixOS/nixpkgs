{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  hatch-vcs,
  hatchling,
  pytest-asyncio,
  pytestCheckHook,
  syrupy,
}:

buildPythonPackage (finalAttrs: {
  pname = "fronius-solarapi";
  version = "0.1.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "farmio";
    repo = "fronius-solarapi";
    tag = finalAttrs.version;
    hash = "sha256-6j0DdKyfMF2utS6JMG8t3VyezYSFtA9HEy4qZmwGlCA=";
  };

  build-system = [
    hatch-vcs
    hatchling
  ];

  dependencies = [
    aiohttp
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
    syrupy
  ];

  pythonImportsCheck = [ "fronius_solarapi" ];

  meta = {
    description = "Async Python library for the Fronius Solar API (v0 and v1), built on aiohttp";
    homepage = "https://github.com/farmio/fronius-solarapi";
    changelog = "https://github.com/farmio/fronius-solarapi/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl3Plus;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
})
