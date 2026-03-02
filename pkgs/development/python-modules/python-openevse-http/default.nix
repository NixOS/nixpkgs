{
  lib,
  aiohttp,
  aioresponses,
  awesomeversion,
  buildPythonPackage,
  fetchFromGitHub,
  freezegun,
  pytestCheckHook,
  pytest-asyncio,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "python-openevse-http";
  version = "0.2.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "firstof9";
    repo = "python-openevse-http";
    tag = finalAttrs.version;
    hash = "sha256-aI1IU9mGThg9tNAqdgKAG5miuVDQozWJoBaoy3cFhwY=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    awesomeversion
  ];

  nativeCheckInputs = [
    aioresponses
    freezegun
    pytestCheckHook
    pytest-asyncio
  ];

  pythonImportsCheck = [ "openevsehttp" ];

  meta = {
    description = "Python wrapper for OpenEVSE HTTP API";
    homepage = "https://github.com/firstof9/python-openevse-http";
    changelog = "https://github.com/firstof9/python-openevse-http/releases/tag/${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
})
