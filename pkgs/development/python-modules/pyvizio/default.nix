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
  version = "0.1.63";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-bRdxIqU3euzrtMvD00nPxOD69VWP2vkGZHxUe3O/YP8=";
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
