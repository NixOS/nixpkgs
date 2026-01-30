{
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  pytest-asyncio,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "pyairobotrest";
  version = "0.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mettolen";
    repo = "pyairobotrest";
    tag = finalAttrs.version;
    hash = "sha256-PYrxQgWlcF7a/gwbJLL1JFrM+5HM3nQco9Yzy3qV1HM=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
  ];

  pythonImportsCheck = [ "pyairobotrest" ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  meta = {
    changelog = "https://github.com/mettolen/pyairobotrest/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    description = "Python library for controlling Airobot TE1 thermostats via local REST API";
    homepage = "https://github.com/mettolen/pyairobotrest";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.dotlambda ];
  };
})
