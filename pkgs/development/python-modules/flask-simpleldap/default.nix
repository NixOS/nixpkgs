{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  flask,
  python-ldap,
  setuptools,
}:

buildPythonPackage rec {
  pname = "flask-simpleldap";
  version = "2.0.0";
  pyproject = true;

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

  meta = {
    description = "LDAP authentication extension for Flask";
    homepage = "https://github.com/alexferl/flask-simpleldap";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kip93 ];
  };
}
