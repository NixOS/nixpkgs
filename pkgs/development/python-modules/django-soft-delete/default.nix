{
  lib,
  buildPythonPackage,
  fetchPypi,
  django,
  hatchling,
}:

buildPythonPackage rec {
  pname = "django-soft-delete";
  version = "1.0.18";
  pyproject = true;

  src = fetchPypi {
    pname = "django_soft_delete";
    inherit version;
    hash = "sha256-0vnbRJpPAI6XhvgvpLr75AdfegsyhIRHNQB+mIsqTfY=";
  };

  build-system = [ hatchling ];

  dependencies = [ django ];

  # No tests
  doCheck = false;

  pythonImportsCheck = [ "django_softdelete" ];

  meta = {
    description = "Soft delete models, managers, queryset for Django";
    homepage = "https://github.com/san4ezy/django_softdelete";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
