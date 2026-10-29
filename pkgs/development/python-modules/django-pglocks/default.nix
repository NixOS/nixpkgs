{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  django,
  six,
}:

buildPythonPackage (finalAttrs: {
  pname = "django-pglocks";
  version = "1.0.4";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-PEfGb7+9Jo70YmlnOgUWoDlTmwlyuO0uyc/uRMS2VSM=";
  };

  build-system = [ setuptools ];

  buildInputs = [ django ];

  dependencies = [
    django
    six
  ];

  # tests need a postgres database
  doCheck = false;

  pythonImportsCheck = [ "django_pglocks" ];

  meta = {
    description = "PostgreSQL locking context managers and functions for Django";
    homepage = "https://github.com/Xof/django-pglocks";
    license = lib.licenses.mit;
  };
})
