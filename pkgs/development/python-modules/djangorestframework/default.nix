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
  version = "3.18.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "encode";
    repo = "django-rest-framework";
    tag = finalAttrs.version;
    hash = "sha256-ZOzGJOIyN6X7NxplIDUeII87IlsXViNLPeW7f4/vIfY=";
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

  disabledTestPaths = lib.optionals (lib.versionAtLeast django.version "6") [
    # AssertionError: assert '�\\u0125\\u01a6.txt' == 'ÀĥƦ.txt'"
    "tests/test_parsers.py::TestFileUploadParser::test_get_encoded_filename"
  ];

  pythonImportsCheck = [ "rest_framework" ];

  meta = {
    changelog = "https://github.com/encode/django-rest-framework/releases/tag/${finalAttrs.src.tag}";
    description = "Web APIs for Django, made easy";
    homepage = "https://www.django-rest-framework.org/";
    license = lib.licenses.bsd2;
  };
})
