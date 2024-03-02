{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder

# build-system
, setuptools

# dependencies
, flask
, werkzeug

# tests
, asgiref
, blinker
, pytestCheckHook
, semantic-version
}:

buildPythonPackage rec {
  pname = "flask-login";
  version = "0.6.3";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "Flask-Login";
    inherit version;
    hash = "sha256-XiPRSmB+8SgGxplZC4nQ8ODWe67sWZ11lHv5wUczAzM=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    flask
    werkzeug
  ];

  pythonImportsCheck = [
    "flask_login"
  ];

  nativeCheckInputs = [
    asgiref
    blinker
    pytestCheckHook
    semantic-version
  ];

  meta = with lib; {
    changelog = "https://github.com/maxcountryman/flask-login/blob/${version}/CHANGES.md";
    description = "User session management for Flask";
    homepage = "https://github.com/maxcountryman/flask-login";
    license = licenses.mit;
    maintainers = with maintainers; [ abbradar ];
  };
}
