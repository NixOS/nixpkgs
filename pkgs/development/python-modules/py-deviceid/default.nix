{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "py-deviceid";
  version = "0.1.0";
  pyproject = true;

  src = fetchPypi {
    pname = "py_deviceid";
    inherit version;
    hash = "sha256-RZBA/eCyhWPjx1//2Y8zPhmZ5BzEoNCYc+AFC9UNkEk=";
  };

  build-system = [
    setuptools
  ];

  pythonImportsCheck = [
    "deviceid"
  ];

  meta = {
    description = "A simple library to get or create a unique device id for a device in Python";
    homepage = "https://pypi.org/project/py-deviceid/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ katexochen ];
  };
}
