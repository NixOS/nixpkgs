{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  flask,
  flask-migrate,
  flask-sqlalchemy,
  ldap3,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "automx2";
  version = "2025.1.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "rseichter";
    repo = "automx2";
    tag = version;
    hash = "sha256-wsKE1lplFUOi6i12ZMV9Oidc58jyuYawbAxJ4qqcYmg=";
  };

  build-system = [ setuptools ];

  dependencies = [
    flask
    flask-migrate
    flask-sqlalchemy
    ldap3
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "automx2" ];

  meta = {
    description = "Email client configuration made easy";
    homepage = "https://rseichter.github.io/automx2/";
    changelog = "https://github.com/rseichter/automx2/blob/${version}/CHANGELOG";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ twey ];
  };
}
