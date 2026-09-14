{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  aiofiles,
  aiohttp,
  gtfs-realtime-bindings,
  pytestCheckHook,
  pytest-asyncio,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "py-nymta";
  version = "0.4.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "OnFreund";
    repo = "py-nymta";
    tag = finalAttrs.version;
    hash = "sha256-K7GJ8UsUjgdlzQ0AWhVN3dIJMWpRy82L2kp0m03A+tE=";
  };

  build-system = [ setuptools ];

  pythonRelaxDeps = [
    "gtfs-realtime-bindings"
  ];

  dependencies = [
    aiofiles
    aiohttp
    gtfs-realtime-bindings
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-asyncio
    writableTmpDirAsHomeHook
  ];

  pythonImportsCheck = [ "pymta" ];

  meta = {
    description = "Python library for accessing MTA real-time transit data for NYC";
    homepage = "https://github.com/OnFreund/py-nymta";
    changelog = "https://github.com/OnFreund/py-nymta/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
})
