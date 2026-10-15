{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  flask,
  flask-migrate,
  flask-sqlalchemy,
  ldap3,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "automx2";
  version = "2026.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "rseichter";
    repo = "automx2";
    tag = version;
    hash = "sha256-7tMcX4BZ6yxlYGy2/3Ffr0X7xtPgcC9YtKcoz1i32sM=";
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
