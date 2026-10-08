{
  lib,
  buildPythonPackage,
  fetchPypi,
  django,
  hatchling,
}:

buildPythonPackage rec {
  pname = "django-soft-delete";
  version = "1.0.23";
  pyproject = true;

  src = fetchPypi {
    pname = "django_soft_delete";
    inherit version;
    hash = "sha256-gUZZ8NGdTyr8WLMf9z+I8K9mcVzO87T82PazoBHVmyo=";
  };

  build-system = [ hatchling ];

  dependencies = [ django ];

  # No tests
  doCheck = false;

  pythonImportsCheck = [ "django_softdelete" ];

  meta = {
    changelog = "https://github.com/san4ezy/django_softdelete/blob/master/CHANGELOG.md";
    description = "Soft delete models, managers, queryset for Django";
    homepage = "https://github.com/san4ezy/django_softdelete";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
