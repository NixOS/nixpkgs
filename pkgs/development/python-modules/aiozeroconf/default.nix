{
  lib,
  buildPythonPackage,
  fetchPypi,
  netifaces,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "aiozeroconf";
  version = "0.1.8";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ENupazLlOqfwHugNLEgeTZjPOYxRgznuCKHpU5unlxw=";
  };

  build-system = [ setuptools ];

  dependencies = [ netifaces ];

  pythonImportsCheck = [ "aiozeroconf" ];

  meta = {
    description = "Implementation of multicast DNS service discovery";
    homepage = "https://github.com/jstasiak/python-zeroconf";
    license = lib.licenses.lgpl21Only;
    maintainers = with lib.maintainers; [ obadz ];
    mainProgram = "aiozeroconf";
  };
}
