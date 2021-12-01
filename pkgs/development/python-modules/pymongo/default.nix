{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pymongo";
  version = "3.12.0";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-uI0XQhWbyToHhzP5eJ9WPO8m9eNw66gQR2pxqpjl+8I=";
  };

  # Tests call a running mongodb instance
  doCheck = false;

  pythonImportsCheck = [ "pymongo" ];

  meta = with lib; {
    description = "Python driver for MongoDB";
    homepage = "https://github.com/mongodb/mongo-python-driver";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
