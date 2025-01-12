{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pytestCheckHook,
  django-extensions,
  factory-boy,
  dj-database-url,
  pytest-django,
}:

buildPythonPackage rec {
  pname = "django-object-actions";
  version = "4.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "crccheck";
    repo = "django-object-actions";
    rev = "refs/tags/v${version}";
    hash = "sha256-qhwn4yg/LzKcSo4SDEYBdSfnfJXsr59avx0uLlufDYw=";
  };

  build-system = [
    poetry-core
  ];

  nativeCheckInputs = [
    pytestCheckHook
    django-extensions
    pytest-django
    factory-boy
    dj-database-url
  ];

  preCheck = ''
    export DJANGO_SETTINGS_MODULE='example_project.settings'
  '';

  disabledTests = [
    "test_action_on_a_model_with_arbitrary_pk_works"
    "test_action_on_a_model_with_slash_in_pk_works"
  ];

  pythonImportsCheck = [ "django_object_actions" ];

  meta = {
    changelog = "https://github.com/crccheck/django-object-actions/releases/tag/v${version}";
    description = "Django app for easily adding object tools in the Django admin";
    homepage = "https://github.com/crccheck/django-object-actions";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ pyrox0 ];
  };
}
