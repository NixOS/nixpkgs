{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  django,
  dj-database-url,
  inflection,
  pydantic,
  pytestCheckHook,
  pytest-django,
  djangorestframework,
  pyyaml,
  setuptools,
  syrupy,
  uritemplate,
}:

buildPythonPackage rec {
  pname = "django-pydantic-field";
<<<<<<< HEAD
  version = "0.4.1";
=======
  version = "0.4.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    owner = "surenkov";
    repo = "django-pydantic-field";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-AyI58ij6bMs0i1bwgpBTpEqjYxVo0qC6xBz43iJiHrc=";
=======
    hash = "sha256-A3P8s6XiMWE3Ob/w/PDiO7ppJG6ACXSX/fAEYCWper4=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  build-system = [ setuptools ];

  dependencies = [
    django
    pydantic
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-django
    djangorestframework
    dj-database-url
    inflection
    pyyaml
    syrupy
    uritemplate
  ];

  preCheck = ''
    export DJANGO_SETTINGS_MODULE=tests.settings.django_test_settings
  '';

<<<<<<< HEAD
  meta = {
=======
  meta = with lib; {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    changelog = "https://github.com/surenkov/django-pydantic-field/releases/tag/${src.tag}";
    description = "Django JSONField with Pydantic models as a Schema";
    homepage = "https://github.com/surenkov/django-pydantic-field";
    maintainers = with lib.maintainers; [ kiara ];
<<<<<<< HEAD
    license = lib.licenses.mit;
=======
    license = licenses.mit;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
