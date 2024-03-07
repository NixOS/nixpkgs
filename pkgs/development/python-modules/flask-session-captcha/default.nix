{ lib
, fetchFromGitHub
, buildPythonPackage
, flask
, flask-sessionstore
, flask-sqlalchemy
, captcha
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "flask-session-captcha";
  version = "1.3.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "Tethik";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-V0f3mXCfqwH2l3OtJKOHGdrlKAFxs2ynqXvNve7Amkc=";
  };

  propagatedBuildInputs = [ flask flask-sessionstore captcha ];

  pythonImportsCheck = [ "flask_session_captcha" ];

  nativeCheckInputs = [ flask-sqlalchemy pytestCheckHook ];

  # RuntimeError: Working outside of application context.
  doCheck = false;

  meta = with lib; {
    description = "A captcha implemention for flask";
    homepage = "https://github.com/Tethik/flask-session-captcha";
    license = licenses.mit;
    maintainers = with maintainers; [ Flakebi ];
  };
}
