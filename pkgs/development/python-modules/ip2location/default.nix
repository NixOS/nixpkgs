{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "ip2location";
  version = "8.11.0";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-REFJp0H2V113Ec9UFM+4HwxE+DDi6Uq5aNdGZfi6qjE=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "IP2Location" ];

  meta = {
    description = "IP geolocation library that enables the user to find the several information regarding the address";
    homepage = "https://www.ip2location.com";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ felbinger ];
  };
})
