{
  lib,
  buildPythonPackage,
  fetchPypi,
  django,
  setuptools,
}:

buildPythonPackage rec {
  pname = "django-soft-delete";
  version = "1.0.13";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-RDwApUwG0jb/iAbDJgJD13XMU2WB1zd8J4UICxBBzh0=";
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
