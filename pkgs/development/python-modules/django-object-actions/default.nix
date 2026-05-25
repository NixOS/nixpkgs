{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
  django-extensions,
  factory-boy,
  dj-database-url,
  pytest-django,
}:

buildPythonPackage (finalAttrs: {
  pname = "django-object-actions";
  version = "5.1.1";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "crccheck";
    repo = "django-object-actions";
    tag = "v${finalAttrs.version}";
    hash = "sha256-13GUnJPtezFFsMhMUCpFjmMRLE6xEa4r1snJVUddJPk=";
  };

  build-system = [
    setuptools
  ];

  nativeCheckInputs = [
    pytestCheckHook
    django-extensions
    pytest-django
    factory-boy
    dj-database-url
  ];

  env.DJANGO_SETTINGS_MODULE = "example_project.settings";

  disabledTests = [
    # These tests use string-keyed PKs which differ from the default integer PK setup
    "test_action_on_a_model_with_arbitrary_pk_works"
    "test_action_on_a_model_with_slash_in_pk_works"
  ];

  pythonImportsCheck = [ "django_object_actions" ];

  meta = {
    changelog = "https://github.com/crccheck/django-object-actions/blob/v${finalAttrs.version}/CHANGELOG.md";
    description = "Django app for easily adding object tools in the Django admin";
    homepage = "https://github.com/crccheck/django-object-actions";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ philocalyst ];
  };
})
