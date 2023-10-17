{ lib
, asgiref
, blinker
, buildPythonPackage
, fetchFromGitHub
, flask
, pytestCheckHook
, pythonAtLeast
, pythonOlder
, semantic-version
, werkzeug
}:

buildPythonPackage rec {
  pname = "flask-login";
  version = "unstable-2023-10-17";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "maxcountryman";
    repo = pname;
    # no new release since Jul 2022
    # newer release needed for compatibility with newer flask
    rev = "2204b4eee7b215977ba5a1bf85e2061f7fa65e20";
    hash = "sha256-7QVPrD5AF1jb5czOh8FxAE778eyLDVhKIH5Mg77kiR4=";
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
