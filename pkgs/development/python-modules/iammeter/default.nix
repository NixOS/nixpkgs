{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchPypi,
  requests,
  setuptools,
  voluptuous,
}:

buildPythonPackage rec {
  pname = "iammeter";
  version = "0.3.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-D6CIk0G5c8E7Fmiz/rb1blXh4Ryi3Ld6hF++14U1LyI=";
  };

  pythonRelaxDeps = [ "aiohttp" ];

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    requests
    voluptuous
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "iammeter" ];

  meta = {
    description = "Module to work with the IamMeter API";
    homepage = "https://pypi.org/project/iammeter/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
