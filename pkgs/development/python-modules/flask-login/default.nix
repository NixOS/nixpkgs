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
  version = "0.6.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    pname = "Flask-Login";
    inherit version;
    sha256 = "sha256-qoT8+0w88JyljAjoFre85z8TSboc8T0A2N/8WHLV/PY=";
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
