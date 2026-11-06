{
  lib,
  buildPythonPackage,
  fetchPypi,

  # build-system
  hatchling,

  # dependencies
  aiofiles,
  aiohttp,

  # tests
  mock,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "evolutionhttp";
  version = "0.1.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-idsvna8V3o2LDmcxMSrWr4AioiW0zjnKevpE0X922AA=";
  };

  build-system = [ hatchling ];

  dependencies = [
    aiofiles
    aiohttp
  ];

  nativeCheckInputs = [
    mock
    pytestCheckHook
  ];

  pythonImportsCheck = [ "evolutionhttp" ];

  meta = {
    description = "HTTP client for controlling a Bryant Evolution HVAC system";
    homepage = "https://github.com/danielsmyers/evolutionhttp";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ hexa ];
  };
}
