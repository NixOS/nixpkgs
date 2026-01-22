{
  lib,
  aiohttp,
  buildPythonPackage,
  click,
  fetchPypi,
  jsonpickle,
  requests,
  setuptools,
  tabulate,
  xmltodict,
  zeroconf,
}:

buildPythonPackage (finalAttrs: {
  pname = "pyvizio";
  version = "0.1.64";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-P31vxmpaaPYxpKZPXoXDmNi4iNycTJdlXLGa7XjRLeY=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    click
    jsonpickle
    requests
    tabulate
    xmltodict
    zeroconf
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "pyvizio" ];

  meta = {
    description = "Python client for Vizio SmartCast";
    homepage = "https://github.com/vkorn/pyvizio";
    changelog = "https://github.com/raman325/pyvizio/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "pyvizio";
  };
})
