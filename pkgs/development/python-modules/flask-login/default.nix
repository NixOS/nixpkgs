{ lib
, blinker
, buildPythonPackage
, fetchPypi
, flask
, pytestCheckHook
, pythonAtLeast
, pythonOlder
, semantic-version
, werkzeug
}:

buildPythonPackage rec {
  pname = "flask-login";
  version = "0.5.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    pname = "Flask-Login";
    inherit version;
    sha256 = "6d33aef15b5bcead780acc339464aae8a6e28f13c90d8b1cf9de8b549d1c0b4b";
  };

  propagatedBuildInputs = [
    flask
    werkzeug
  ];

  checkInputs = [
    blinker
    pytestCheckHook
    semantic-version
  ];

  disabledTests = lib.optionals (pythonAtLeast "3.10") [
    "test_hashable"
  ];

  pythonImportsCheck = [
    "flask_login"
  ];

  meta = with lib; {
    description = "User session management for Flask";
    homepage = "https://github.com/maxcountryman/flask-login";
    license = licenses.mit;
    maintainers = with maintainers; [ abbradar ];
  };
}
