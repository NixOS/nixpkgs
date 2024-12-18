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
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "flask-session-captcha";
  version = "1.4.2";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "Tethik";
    repo = "flask-session-captcha";
    rev = "refs/tags/v${version}";
    hash = "sha256-hf6ifTrsWvgvUHFAPdS8ns8aKN02zquLGCq5ouQF0ck=";
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

  meta = with lib; {
    description = "Captcha implemention for flask";
    homepage = "https://github.com/Tethik/flask-session-captcha";
    changelog = "https://github.com/Tethik/flask-session-captcha/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ Flakebi ];
  };
}
