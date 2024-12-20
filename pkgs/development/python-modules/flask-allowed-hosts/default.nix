{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  flask,
}:

buildPythonPackage rec {
  pname = "flask-allowed-hosts";
  version = "1.2.0";
  pyproject = true;

  src = fetchPypi {
    inherit version;
    pname = "flask_allowed_hosts";
    hash = "sha256-LL0Vm33R0BYo8IKyjAzpvO7ls4EfcPx3cx3OU6OsE6s=";
  };

  build-system = [ setuptools ];

  dependencies = [ flask ];

  pythonImportsCheck = [ "flask_allowed_hosts" ];

  meta = with lib; {
    description = "Flask extension that helps you limit access to your API endpoints";
    homepage = "https://github.com/riad-azz/flask-allowedhosts";
    license = licenses.mit;
    maintainers = with maintainers; [ erictapen ];
  };
}
