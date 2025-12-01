{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  django,
  pytz,

  # optional-dependencies
  django-taggit,

  # tests
  pytest-django,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "django-modelcluster";
  version = "6.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "wagtail";
    repo = "django-modelcluster";
    tag = "v${version}";
    hash = "sha256-JoDDHvZ9N+7hcIxRsbVrYW8/95iUcNHDQkvtmDVUzws=";
  };

  build-system = [ setuptools ];

  dependencies = [
    django
    pytz
  ];

  optional-dependencies.taggit = [ django-taggit ];

  env.DJANGO_SETTINGS_MODULE = "tests.settings";

  nativeCheckInputs = [
    pytest-django
    pytestCheckHook
  ]
  ++ optional-dependencies.taggit;

  pythonImportsCheck = [ "modelcluster" ];

  meta = {
    description = "Django extension to allow working with 'clusters' of models as a single unit, independently of the database";
    homepage = "https://github.com/torchbox/django-modelcluster/";
    changelog = "https://github.com/wagtail/django-modelcluster/blob/${src.tag}/CHANGELOG.txt";
    license = lib.licenses.bsd2;
  };
}
