{
  lib,
  buildPythonPackage,
  fetchPypi,
  django,
  hatchling,
}:

buildPythonPackage rec {
  pname = "django-soft-delete";
  version = "1.0.22";
  pyproject = true;

  src = fetchPypi {
    pname = "django_soft_delete";
    inherit version;
    hash = "sha256-MtC7lfGAwopAFj54pViswYkB/VYBH5H47nNcFxptQkQ=";
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
