{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "py-deviceid";
  version = "0.1.1";
  pyproject = true;

  src = fetchPypi {
    pname = "py_deviceid";
    inherit version;
    hash = "sha256-w+dXetojZm5/OeaTcN/ap2/p3nnAJjU3bWqgIpv6MOM=";
  };

  build-system = [
    setuptools
  ];

  pythonImportsCheck = [
    "deviceid"
  ];

  meta = {
    description = "Simple library to get or create a unique device id for a device in Python";
    homepage = "https://pypi.org/project/py-deviceid/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ katexochen ];
  };
}
