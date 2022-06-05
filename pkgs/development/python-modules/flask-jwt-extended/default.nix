{ lib
, buildPythonPackage
, fetchPypi
, flask
, pyjwt
, pytestCheckHook
, python-dateutil
, pythonOlder
, werkzeug
}:

buildPythonPackage rec {
  pname = "flask-jwt-extended";
  version = "4.4.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "Flask-JWT-Extended";
    inherit version;
    hash = "sha256-CYh/o3K91Omrtg2KcVWpZr8Rt0mZVUQQsgl1gCrsJ34=";
  };

  propagatedBuildInputs = [
    flask
    pyjwt
    python-dateutil
    werkzeug
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "flask_jwt_extended"
  ];

  meta = with lib; {
    description = "JWT extension for Flask";
    homepage = "https://flask-jwt-extended.readthedocs.io/";
    license = licenses.mit;
    maintainers = with maintainers; [ gerschtli ];
  };
}
