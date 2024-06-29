{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, flask
, python-ldap
}:

buildPythonPackage rec {
  pname = "flask-simpleldap";
  version = "1.4.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "alexferl";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-tFZ7eUHuhcmfN6QbC6J6wQ8cXBg2lSZSLzl3W68FjFw=";
  };

  propagatedBuildInputs = [
    flask
    python-ldap
  ];

  pythonImportsCheck = [
    "flask_simpleldap"
  ];

  meta = with lib; {
    description = "LDAP authentication extension for Flask";
    homepage = "https://github.com/alexferl/flask-simpleldap";
    license = licenses.mit;
    maintainers = with maintainers; [ kip93 ];
  };
}
