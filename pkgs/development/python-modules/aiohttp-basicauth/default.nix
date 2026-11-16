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
  pname = "aiohttp-basicauth";
  version = "1.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "romis2012";
    repo = "aiohttp-basicauth";
    tag = "v${finalAttrs.version}";
    hash = "sha256-EnrICetTmQimScjaQ8/jviwwansbZtl35Z5v35rF7kU=";
  };

  build-system = [ setuptools ];

  dependencies = [ aiohttp ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "aiohttp_basicauth" ];

  meta = {
    description = "HTTP basic authentication middleware for aiohttp";
    homepage = "https://github.com/romis2012/aiohttp-basicauth";
    changelog = "https://github.com/romis2012/aiohttp-basicauth/releases/tag/v${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
})
