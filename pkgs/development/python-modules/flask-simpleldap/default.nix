{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  flask,
  python-ldap,
  setuptools,
}:

buildPythonPackage rec {
  pname = "flask-simpleldap";
  version = "2.0.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "alexferl";
    repo = "flask-simpleldap";
    tag = "v${version}";
    hash = "sha256-WcedTtEwaSc3BYFE3L0FZrtKKdbwk7r3qSPP8evtYlc=";
  };

  build-system = [
    setuptools
  ];
  dependencies = [
    flask
    python-ldap
  ];

  pythonImportsCheck = [ "flask_simpleldap" ];

  meta = with lib; {
    description = "LDAP authentication extension for Flask";
    homepage = "https://github.com/alexferl/flask-simpleldap";
    license = licenses.mit;
    maintainers = with maintainers; [ kip93 ];
  };
}
