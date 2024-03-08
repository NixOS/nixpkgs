{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, dnspython
}:

buildPythonPackage rec {
  pname = "pymongo";
  version = "4.6.2";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-q30BrIMqFmPa1ZLMvZK7Dwd1vI+YoZI8Xhp9f+rUla8=";
  };

  propagatedBuildInputs = [
    dnspython
  ];

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
