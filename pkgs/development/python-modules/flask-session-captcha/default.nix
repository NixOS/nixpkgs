{ lib
, fetchFromGitHub
, fetchpatch
, buildPythonPackage

# build-system
, setuptools

# dependencies
, captcha
, flask
, markupsafe

# tests
, flask-sqlalchemy
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "flask-session-captcha";
  version = "1.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Tethik";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-V0f3mXCfqwH2l3OtJKOHGdrlKAFxs2ynqXvNve7Amkc=";
  };

  patches = [
    (fetchpatch {
      # https://github.com/Tethik/flask-session-captcha/pull/44
      url = "https://github.com/Tethik/flask-session-captcha/commit/3f79c22a71c60dd60e9df61b550cce641603dcb6.patch";
      hash = "sha256-MXsoSytBNbcg3HU6IWlvf2MgNUL78T5ToxKGv4YMtZw=";
    })
  ];

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    captcha
    flask
    markupsafe
  ];

  pythonImportsCheck = [
    "flask_session_captcha"
  ];

  # RuntimeError: Working outside of application context.
  doCheck = false;

  nativeCheckInputs = [
    flask-sqlalchemy
    pytestCheckHook
  ];

  meta = with lib; {
    description = "A captcha implemention for flask";
    homepage = "https://github.com/Tethik/flask-session-captcha";
    license = licenses.mit;
    maintainers = with maintainers; [ Flakebi ];
  };
}
