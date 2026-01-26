{
  lib,
  buildPythonPackage,
  captcha,
  fetchFromGitHub,
  flask,
  flask-session,
  flask-sqlalchemy,
  markupsafe,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "flask-session-captcha";
  version = "1.5.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Tethik";
    repo = "flask-session-captcha";
    tag = "v${version}";
    hash = "sha256-2JPJx8yQIl0bbcbshONJtja7BnSiieHzHi64A6jLpc0=";
  };

  build-system = [ setuptools ];

  dependencies = [
    captcha
    flask
    markupsafe
  ];

  nativeCheckInputs = [
    flask-session
    flask-sqlalchemy
    pytestCheckHook
  ];

  pythonImportsCheck = [ "flask_session_captcha" ];

  meta = {
    description = "Captcha implemention for flask";
    homepage = "https://github.com/Tethik/flask-session-captcha";
    changelog = "https://github.com/Tethik/flask-session-captcha/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ Flakebi ];
  };
}
