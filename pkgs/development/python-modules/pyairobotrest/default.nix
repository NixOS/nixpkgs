{
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  pytest-asyncio,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pyairobotrest";
  version = "0.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mettolen";
    repo = "pyairobotrest";
    tag = "v${version}";
    hash = "sha256-MqZV8+uwKLIbh0A/lYMB/9iPDl/8a4IAoYMdoxiIJqY=";
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
    changelog = "https://github.com/mettolen/pyairobotrest/blob/${src.tag}/CHANGELOG.md";
    description = "Python library for controlling Airobot TE1 thermostats via local REST API";
    homepage = "https://github.com/mettolen/pyairobotrest";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.dotlambda ];
  };
}
