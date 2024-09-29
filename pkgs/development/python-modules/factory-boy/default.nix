{
  lib,
  buildPythonPackage,
  django,
  faker,
  fetchPypi,
  flask,
  flask-sqlalchemy,
  mongoengine,
  pytestCheckHook,
  pythonOlder,
  mongomock,
  sqlalchemy,
  sqlalchemy-utils,
  setuptools,
}:

buildPythonPackage rec {
  pname = "factory-boy";
  version = "3.3.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    pname = "factory_boy";
    inherit version;
    hash = "sha256-gxeqUonN/EX5yuVw/rB6YXcxbILjTRTfPC4fIvJqvvA=";
  };

  build-system = [ setuptools ];

  dependencies = [ faker ];

  nativeCheckInputs = [
    django
    flask
    flask-sqlalchemy
    mongoengine
    mongomock
    pytestCheckHook
    sqlalchemy
    sqlalchemy-utils
  ];

  disabledTests = [
    # Test checks for MongoDB requires an a running DB
    "MongoEngineTestCase"
  ];

  disabledTestPaths = [
    # incompatible with latest flask-sqlalchemy
    "examples/flask_alchemy/test_demoapp.py"
  ];

  pythonImportsCheck = [ "factory" ];

  meta = with lib; {
    description = "Python package to create factories for complex objects";
    homepage = "https://github.com/rbarrois/factory_boy";
    changelog = "https://github.com/FactoryBoy/factory_boy/blob/${version}/docs/changelog.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
