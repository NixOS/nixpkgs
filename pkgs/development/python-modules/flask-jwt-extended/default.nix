{ lib
, buildPythonPackage
, fetchPypi
, cryptography
, flask
, pyjwt
, pytestCheckHook
, python-dateutil
, pythonOlder
, werkzeug
}:

buildPythonPackage rec {
  pname = "flask-jwt-extended";
<<<<<<< HEAD
  version = "4.5.2";
=======
  version = "4.4.4";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "Flask-JWT-Extended";
    inherit version;
<<<<<<< HEAD
    hash = "sha256-ulYkW6Q7cciuk2eEuGdiXc6LmVb67t7ClTIi5XlC+ws=";
=======
    hash = "sha256-YrUh11SUwpCmRq6KzHcSNyHkNkeQ8eZK8AONgjlh+/A=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    flask
    pyjwt
    python-dateutil
    werkzeug
  ];

  passthru.optional-dependencies.asymmetric_crypto = [
    cryptography
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ]
  ++ lib.flatten (lib.attrValues passthru.optional-dependencies);

  pythonImportsCheck = [
    "flask_jwt_extended"
  ];

  meta = with lib; {
<<<<<<< HEAD
    changelog = "https://github.com/vimalloc/flask-jwt-extended/releases/tag/${version}";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    description = "JWT extension for Flask";
    homepage = "https://flask-jwt-extended.readthedocs.io/";
    license = licenses.mit;
    maintainers = with maintainers; [ gerschtli ];
  };
}
