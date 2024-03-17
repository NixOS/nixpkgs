{ lib
, fetchFromGitHub
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
  version = "1.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Tethik";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-eLdpLw1I4t9H0ek3AR9Cteb7Gfxo/LepM287p34Zw3s=";
  };

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
