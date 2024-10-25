{
  lib,
  buildPythonPackage,
  fetchPypi,
  django,
  setuptools,
}:

buildPythonPackage rec {
  pname = "django-soft-delete";
  version = "1.0.14";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Qo31bqT7sT9C1PdS8R8qUXqjGsPRtFDmt4xMXV2d/Ds=";
  };

  dependencies = [ django ];

  build-system = [ setuptools ];

  # No tests
  doCheck = false;

  meta = {
    description = "Soft delete models, managers, queryset for Django";
    homepage = "https://github.com/san4ezy/django_softdelete";
    license = lib.licenses.mit;
  };
}
