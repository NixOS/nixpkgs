{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, setuptools
, flask
, mysqlclient
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "flask-mysqldb";
  version = "2.0.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "alexferl";
    repo = "flask-mysqldb";
    rev = "v${version}";
    hash = "sha256-RHAB9WGRzojH6eAOG61QguwF+4LssO9EcFjbWxoOtF4=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    flask
    mysqlclient
  ];

  pythonImportsCheck = [
    "flask_mysqldb"
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = with lib; {
    description = "MySQL connection support for Flask";
    homepage = "https://github.com/alexferl/flask-mysqldb";
    changelog = "https://github.com/alexferl/flask-mysqldb/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ netali ];
  };
}
