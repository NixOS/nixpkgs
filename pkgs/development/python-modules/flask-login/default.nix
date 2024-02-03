{ lib
, asgiref
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
  version = "0.6.2";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    pname = "Flask-Login";
    inherit version;
    hash = "sha256-wKe6qf3ESM3T3W8JOd9y7sUXey96vmy4L8k00pyqycM=";
  };

  propagatedBuildInputs = [
    flask
    werkzeug
  ];

  nativeCheckInputs = [
    asgiref
    blinker
    pytestCheckHook
    semantic-version
  ];

  disabledTests = [
    # https://github.com/maxcountryman/flask-login/issues/747
    "test_remember_me_accepts_duration_as_int"
    "test_remember_me_custom_duration_uses_custom_cookie"
    "test_remember_me_refresh_every_request"
    "test_remember_me_uses_custom_cookie_parameters"
  ] ++ lib.optionals (pythonAtLeast "3.10") [
    "test_hashable"
  ];

  pytestFlagsArray = [
    "-W" "ignore::DeprecationWarning"
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
