{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  flask,
  python3-openid,
}:

buildPythonPackage rec {
  pname = "flask-openid";
  version = "1.3.1";
  pyproject = true;

  src = fetchPypi {
    pname = "flask_openid";
    inherit version;
    hash = "sha256-J2KLwKN+ZTCUiCMZPgaNeQNa2Ulth7dAQEQ+xITHZXo=";
  };

  build-system = [ setuptools ];

  dependencies = [
    flask
    python3-openid
  ];

  # no tests for repo...
  doCheck = false;

  meta = with lib; {
    description = "OpenID support for Flask";
    homepage = "https://pythonhosted.org/Flask-OpenID/";
    license = licenses.bsd3;
    maintainers = [ ];
  };
}
