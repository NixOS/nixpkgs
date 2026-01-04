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
  version = "0.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mettolen";
    repo = "pyairobotrest";
    tag = "v${version}";
    hash = "sha256-a0xsmknDe96cOBewhwVLy2Tw5sYffh8lZR4e+q6uGz4=";
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
