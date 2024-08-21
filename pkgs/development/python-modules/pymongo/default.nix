{
  lib,
  buildPythonPackage,
  fetchPypi,
  hatchling,
  hatch-requirements-txt,
  setuptools,
  pythonOlder,
  dnspython,

  # for passthru.tests
  celery, # check-input only
  flask-pymongo,
  kombu, # check-input only
  mongoengine,
  motor,
  pymongo-inmemory,
}:

buildPythonPackage rec {
  pname = "pymongo";
  version = "4.8.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit version;
    pname = "pymongo";
    hash = "sha256-RU8ilYdXRNxw8YgeSy65nNrQCKM1dLyKrxIFMPZsDN4=";
  };

  build-system = [
    hatchling
    hatch-requirements-txt
    setuptools
  ];

  dependencies = [ dnspython ];

  # Tests call a running mongodb instance
  doCheck = false;

  pythonImportsCheck = [ "pymongo" ];

  passthru.tests = {
    inherit
      celery
      flask-pymongo
      kombu
      mongoengine
      motor
      pymongo-inmemory
      ;
  };

  meta = {
    description = "Python driver for MongoDB";
    homepage = "https://github.com/mongodb/mongo-python-driver";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
}
