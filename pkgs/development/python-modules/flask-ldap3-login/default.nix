{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
  flask,
  flask-wtf,
  wtforms,
  ldap3,
  mock,
}:

buildPythonPackage rec {
  pname = "flask-ldap3-login";
  version = "1.0.2";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "nickw444";
    repo = "flask-ldap3-login";
    tag = version;
    hash = "sha256-bWu+hCVnNRSWvXgB2pAcCdhXJQEg3mZeAfZgxUqVOkY=";
  };

  build-system = [ setuptools ];

  dependencies = [
    flask
    flask-wtf
    ldap3
    wtforms
  ];

  nativeCheckInputs = [
    pytestCheckHook
    mock
  ];

  pythonImportsCheck = [ "flask_ldap3_login" ];

  meta = {
    description = "LDAP3 Logins for Flask/Flask-Login";
    homepage = "https://flask-ldap3-login.readthedocs.org";
    changelog = "https://github.com/nickw444/flask-ldap3-login/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ felbinger ];
  };
}
