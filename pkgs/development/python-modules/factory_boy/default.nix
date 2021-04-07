{ lib
, buildPythonPackage
, django
, faker
, fetchPypi
, flask
, flask_sqlalchemy
, mongoengine
, pytestCheckHook
, sqlalchemy
}:

buildPythonPackage rec {
  pname = "factory_boy";
  version = "3.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0nsw2mdjk8sqds3qsix4cf19ws6i0fak79349pw2581ryc7w0720";
  };

  propagatedBuildInputs = [ faker ];

  checkInputs = [
    django
    flask
    flask_sqlalchemy
    mongoengine
    pytestCheckHook
    sqlalchemy
  ];

  # Checks for MongoDB requires an a running DB
  disabledTests = [ "MongoEngineTestCase" ];
  pythonImportsCheck = [ "factory" ];

  meta = with lib; {
    description = "Python package to create factories for complex objects";
    homepage = "https://github.com/rbarrois/factory_boy";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
