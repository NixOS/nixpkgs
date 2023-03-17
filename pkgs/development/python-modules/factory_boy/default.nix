{ lib
, buildPythonPackage
, django
, faker
, fetchPypi
, flask
, flask-sqlalchemy
, mongoengine
, pytestCheckHook
, sqlalchemy
}:

buildPythonPackage rec {
  pname = "factory-boy";
  version = "3.2.1";
  format = "setuptools";

  src = fetchPypi {
    pname = "factory_boy";
    inherit version;
    sha256 = "sha256-qY0newwEfHXrbkq4UIp/gfsD0sshmG9ieRNUbveipV4=";
  };

  propagatedBuildInputs = [
    faker
  ];

  nativeCheckInputs = [
    django
    flask
    flask-sqlalchemy
    mongoengine
    pytestCheckHook
    sqlalchemy
  ];

  # Checks for MongoDB requires an a running DB
  disabledTests = [
    "MongoEngineTestCase"
  ];

  disabledTestPaths = [
    # incompatible with latest flask-sqlalchemy
    "examples/flask_alchemy/test_demoapp.py"
  ];

  pythonImportsCheck = [
    "factory"
  ];

  meta = with lib; {
    description = "Python package to create factories for complex objects";
    homepage = "https://github.com/rbarrois/factory_boy";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
