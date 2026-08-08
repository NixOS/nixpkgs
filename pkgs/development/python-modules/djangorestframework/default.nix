{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

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
  dj-database-url,
  pytestCheckHook,
  pytest-django,
  pytz,
}:

buildPythonPackage (finalAttrs: {
  pname = "djangorestframework";
  version = "3.18.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "encode";
    repo = "django-rest-framework";
    tag = finalAttrs.version;
    hash = "sha256-uepGCXZjXCZLCrQjcg06SSa3idiXwPenip5YvyVMl1A=";
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
    dj-database-url
    pytest-django
    pytestCheckHook
    pytz
  ]
  ++ finalAttrs.passthru.optional-dependencies.complete;

  pythonImportsCheck = [ "rest_framework" ];

  meta = {
    changelog = "https://github.com/encode/django-rest-framework/releases/tag/${finalAttrs.src.tag}";
    description = "Web APIs for Django, made easy";
    homepage = "https://www.django-rest-framework.org/";
    license = lib.licenses.bsd2;
  };
})
