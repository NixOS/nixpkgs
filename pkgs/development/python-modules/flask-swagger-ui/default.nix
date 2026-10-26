{
  lib,
  buildPythonPackage,
  fetchPypi,
  flask,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "flask-swagger-ui";
  version = "5.32.14";
  pyproject = true;

  src = fetchPypi {
    pname = "flask_swagger_ui";
    inherit (finalAttrs) version;
    hash = "sha256-p3lUxjMu7Q+SaCt71+90n2MSf3NlqEqaimh+JvzEOg4=";
  };

  build-system = [ setuptools ];

  dependencies = [ flask ];

  doCheck = false; # there are no tests

  pythonImportsCheck = [ "flask_swagger_ui" ];

  meta = {
    description = "Swagger UI blueprint for Flask";
    homepage = "https://github.com/sveint/flask-swagger-ui";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ vanschelven ];
  };
})
