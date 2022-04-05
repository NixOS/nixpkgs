{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pymongo";
  version = "3.12.3";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-ConK3ABipeU2ZN3gQ/bAlxcrjBxfAJRJAJUoL/mZWl8=";
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
