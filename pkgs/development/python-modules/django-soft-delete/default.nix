{
  lib,
  buildPythonPackage,
  fetchPypi,
  django,
  hatchling,
}:

buildPythonPackage rec {
  pname = "django-soft-delete";
<<<<<<< HEAD
  version = "1.0.22";
=======
  version = "1.0.21";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchPypi {
    pname = "django_soft_delete";
    inherit version;
<<<<<<< HEAD
    hash = "sha256-MtC7lfGAwopAFj54pViswYkB/VYBH5H47nNcFxptQkQ=";
=======
    hash = "sha256-VCvUZQ0naRBaQ2Pqe7f72zwoQp26pmQXFg+PS13GidU=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  build-system = [ hatchling ];

  dependencies = [ django ];

  # No tests
  doCheck = false;

  pythonImportsCheck = [ "django_softdelete" ];

  meta = {
<<<<<<< HEAD
    changelog = "https://github.com/san4ezy/django_softdelete/blob/master/CHANGELOG.md";
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    description = "Soft delete models, managers, queryset for Django";
    homepage = "https://github.com/san4ezy/django_softdelete";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
