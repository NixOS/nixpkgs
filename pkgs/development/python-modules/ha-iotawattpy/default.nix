{
  lib,
  buildPythonPackage,
  fetchPypi,
  httpx,
  setuptools,
}:

buildPythonPackage rec {
  pname = "ha-iotawattpy";
  version = "0.1.2";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-eMsBEbmENjbJME9Gzo4O9LbGo1i0MP0IuwLUAYqxbI8=";
  };

  build-system = [ setuptools ];

  propagatedBuildInputs = [ httpx ];

  # Project doesn't tag releases or ship the tests with PyPI
  # https://github.com/gtdiehl/iotawattpy/issues/14
  doCheck = false;

  pythonImportsCheck = [ "iotawattpy" ];

  meta = {
    description = "Python library for the IoTaWatt Energy device";
    homepage = "https://github.com/gtdiehl/iotawattpy";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ fab ];
  };
}
