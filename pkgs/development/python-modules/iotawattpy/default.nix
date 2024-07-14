{
  lib,
  buildPythonPackage,
  fetchPypi,
  httpx,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "iotawattpy";
  version = "0.1.0";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-g+tXXbobbOC2uWmB3Ec+RkQq5o4y5dMz8N+0TQ+q3d8=";
  };

  propagatedBuildInputs = [ httpx ];

  # Project doesn't tag releases or ship the tests with PyPI
  # https://github.com/gtdiehl/iotawattpy/issues/14
  doCheck = false;

  pythonImportsCheck = [ "iotawattpy" ];

  meta = with lib; {
    description = "Python interface for the IoTaWatt device";
    homepage = "https://github.com/gtdiehl/iotawattpy";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ fab ];
  };
}
