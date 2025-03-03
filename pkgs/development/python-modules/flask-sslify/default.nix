{
  lib,
  fetchPypi,
  buildPythonPackage,
  flask,
  setuptools,
}:

buildPythonPackage rec {
  pname = "flask-sslify";
  version = "0.1.5";
  pyproject = true;

  src = fetchPypi {
    pname = "Flask-SSLify";
    inherit version;
    hash = "sha256-0z4dPAnNlRVBdqqKcxlBjlISn8SC3VbYqK18JFANVD4=";
  };

  build-system = [ setuptools ];

  dependencies = [ flask ];

  # no tests
  doCheck = false;
  pythonImportsCheck = [ "flask_sslify" ];

  meta = {
    description = "Flask extension that redirects all incoming requests to HTTPS";
    homepage = "https://github.com/kennethreitz42/flask-sslify";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ zhaofengli ];
  };
}
