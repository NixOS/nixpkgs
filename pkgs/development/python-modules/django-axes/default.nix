{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  setuptools-scm,
  django,
  django-ipware,
  pytestCheckHook,
  pytest-cov-stub,
  pytest-django,
}:

buildPythonPackage rec {
  pname = "django-axes";
<<<<<<< HEAD
  version = "8.1.0";
=======
  version = "8.0.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jazzband";
    repo = "django-axes";
    tag = version;
<<<<<<< HEAD
    hash = "sha256-yiXj0Wmn9AVKDilmGVTIE+MICmKeO76j2P6jtlt5CFY=";
=======
    hash = "sha256-RV2/s372+yjSqYAqikH0VOJKt7fRAej32sgdOoKR/Do=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  build-system = [ setuptools-scm ];

  dependencies = [ django ];

  nativeCheckInputs = [
    django-ipware
    pytestCheckHook
    pytest-cov-stub
    pytest-django
  ];

  env.DJANGO_SETTINGS_MODULE = "tests.settings";

  pythonImportsCheck = [ "axes" ];

  meta = {
    description = "Keep track of failed login attempts in Django-powered sites";
    homepage = "https://github.com/jazzband/django-axes";
    maintainers = with lib.maintainers; [ sikmir ];
    license = lib.licenses.mit;
  };
}
