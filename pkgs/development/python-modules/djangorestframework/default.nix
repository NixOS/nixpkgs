{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,

  # build-system
  setuptools,

  # dependencies
  django,

  # optional-dependencies
  coreapi,
  coreschema,
  django-guardian,
  inflection,
  psycopg2,
  pygments,
  pyyaml,

  # tests
  pytestCheckHook,
  pytest-django,
  pytz,
}:

buildPythonPackage (finalAttrs: {
  pname = "djangorestframework";
  version = "3.16.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "encode";
    repo = "django-rest-framework";
    tag = finalAttrs.version;
    hash = "sha256-kjviZFuGt/x0RSc7wwl/+SeYQ5AGuv0e7HMhAmu4IgY=";
  };

  build-system = [ setuptools ];

  dependencies = [
    django
  ];

  optional-dependencies = {
    complete = [
      coreapi
      coreschema
      django-guardian
      inflection
      psycopg2
      pygments
      pyyaml
    ];
  };

  nativeCheckInputs = [
    pytest-django
    pytestCheckHook
    pytz
  ]
  ++ finalAttrs.passthru.optional-dependencies.complete;

  disabledTests = [
    # https://github.com/encode/django-rest-framework/issues/9422
    "test_urlpatterns"
  ];

  pythonImportsCheck = [ "rest_framework" ];

  meta = {
    changelog = "https://github.com/encode/django-rest-framework/releases/tag/${finalAttrs.src.tag}";
    description = "Web APIs for Django, made easy";
    homepage = "https://www.django-rest-framework.org/";
    license = lib.licenses.bsd2;
  };
})
