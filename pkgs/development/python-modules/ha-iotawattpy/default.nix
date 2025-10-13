{
  lib,
  buildPythonPackage,
  fetchPypi,
  httpx,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "ha-iotawattpy";
  version = "0.1.2";
  pyproject = true;

  disabled = pythonOlder "3.8";

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

  meta = with lib; {
    description = "Python library for the IoTaWatt Energy device";
    homepage = "https://github.com/gtdiehl/iotawattpy";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ fab ];
  };
}
