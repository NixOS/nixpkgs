{
  lib,
  buildPythonPackage,
  fetchPypi,
  flask,
}:

buildPythonPackage rec {
  pname = "flask-swagger-ui";
  version = "5.32.14";
  format = "setuptools";

  src = fetchPypi {
    pname = "flask_swagger_ui";
    inherit version;
    hash = "sha256-p3lUxjMu7Q+SaCt71+90n2MSf3NlqEqaimh+JvzEOg4=";
  };

  doCheck = false; # there are no tests

  propagatedBuildInputs = [ flask ];

  meta = {
    homepage = "https://github.com/sveint/flask-swagger-ui";
    license = lib.licenses.mit;
    description = "Swagger UI blueprint for Flask";
    maintainers = with lib.maintainers; [ vanschelven ];
  };
}
