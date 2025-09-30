{
  lib,
  buildPythonPackage,
  django-taggit,
  django,
  fetchFromGitHub,
  pytest-django,
  pytestCheckHook,
  pythonOlder,
  pytz,
  setuptools,
}:

buildPythonPackage rec {
  pname = "django-modelcluster";
  version = "6.4";
  pyproject = true;

  disabled = pythonOlder "3.9";

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

  meta = with lib; {
    description = "Django extension to allow working with 'clusters' of models as a single unit, independently of the database";
    homepage = "https://github.com/torchbox/django-modelcluster/";
    changelog = "https://github.com/wagtail/django-modelcluster/blob/v${version}/CHANGELOG.txt";
    license = licenses.bsd2;
  };
}
