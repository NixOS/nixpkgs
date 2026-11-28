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
  version = "3.17.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "encode";
    repo = "django-rest-framework";
    tag = finalAttrs.version;
    hash = "sha256-K2c8o3DEHyhg85RVmvMM7SmmDHp1/SFz42jlcBnKmU4=";
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

  disabledTestPaths = [
    # AssertionError: assert '�\\u0125\\u01a6.txt' == 'ÀĥƦ.txt'"
    "tests/test_parsers.py::TestFileUploadParser::test_get_encoded_filename"
  ];

  pythonImportsCheck = [ "rest_framework" ];

  meta = {
    changelog = "https://github.com/encode/django-rest-framework/releases/tag/${finalAttrs.src.tag}";
    description = "Web APIs for Django, made easy";
    homepage = "https://www.django-rest-framework.org/";
    license = lib.licenses.bsd2;
    knownVulnerabilities = [
      "CVE-2026-114138"
      "CVE-2026-114136"
      "CVE-2026-114137"
    ];
  };
})
