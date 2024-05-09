{ lib
, buildPythonPackage
, django
, faker
, fetchPypi
, flask
, flask-sqlalchemy
, mongoengine
, pytestCheckHook
, pythonOlder
, sqlalchemy
, sqlalchemy-utils
}:

buildPythonPackage rec {
  pname = "factory-boy";
  version = "3.3.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "factory_boy";
    inherit version;
    hash = "sha256-vHbZfRplu9mEKm1yKIIJjrVJ7I7hCB+fsuj/KfDDAPE=";
  };

  postPatch = ''
    substituteInPlace tests/test_version.py \
      --replace '"3.2.1.dev0")' '"${version}")'
  '';

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
    sqlalchemy-utils
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
    changelog = "https://github.com/FactoryBoy/factory_boy/blob/${version}/docs/changelog.rst";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
