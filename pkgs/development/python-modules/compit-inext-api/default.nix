{
  aiofiles,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  setuptools,
}:

buildPythonPackage rec {
  pname = "compit-inext-api";
  version = "0.3.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Przemko92";
    repo = "compit-inext-api";
    tag = version;
    hash = "sha256-Wx3V0AdxNGLdCIl4G7FlfzeDSirRPnxgQ9Fbp5cRjFw=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiofiles
    aiohttp
  ];

  pythonImportsCheck = [ "compit_inext_api" ];

  # upstream has no tests
  doCheck = false;

  meta = {
    description = "Python client for the Compit iNext API";
    homepage = "https://github.com/Przemko92/compit-inext-api";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.dotlambda ];
  };
}
