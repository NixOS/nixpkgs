{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  flask,
  mysqlclient,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "flask-mysqldb";
  version = "2.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "alexferl";
    repo = "flask-mysqldb";
    rev = "v${version}";
    hash = "sha256-RHAB9WGRzojH6eAOG61QguwF+4LssO9EcFjbWxoOtF4=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    flask
    mysqlclient
  ];

  pythonImportsCheck = [ "flask_mysqldb" ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    description = "MySQL connection support for Flask";
    homepage = "https://github.com/alexferl/flask-mysqldb";
    changelog = "https://github.com/alexferl/flask-mysqldb/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ netali ];
  };
}
