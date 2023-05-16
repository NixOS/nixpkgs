{ lib
, buildPythonPackage
, django
, faker
, fetchPypi
, flask
, flask-sqlalchemy
, mongoengine
, pytestCheckHook
<<<<<<< HEAD
, pythonOlder
, sqlalchemy
, sqlalchemy-utils
=======
, sqlalchemy
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonPackage rec {
  pname = "factory-boy";
<<<<<<< HEAD
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

=======
  version = "3.2.1";
  format = "setuptools";

  src = fetchPypi {
    pname = "factory_boy";
    inherit version;
    hash = "sha256-qY0newwEfHXrbkq4UIp/gfsD0sshmG9ieRNUbveipV4=";
  };

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
    sqlalchemy-utils
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
    changelog = "https://github.com/FactoryBoy/factory_boy/blob/${version}/docs/changelog.rst";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
