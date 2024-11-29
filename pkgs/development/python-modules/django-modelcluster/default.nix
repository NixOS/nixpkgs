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
  version = "6.3";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "wagtail";
    repo = "django-modelcluster";
    rev = "refs/tags/v${version}";
    hash = "sha256-AUVl2aidjW7Uu//3HlAod7pxzj6Gs1Xd0uTt3NrrqAU=";
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
  ] ++ optional-dependencies.taggit;

  pythonImportsCheck = [ "modelcluster" ];

  meta = with lib; {
    description = "Django extension to allow working with 'clusters' of models as a single unit, independently of the database";
    homepage = "https://github.com/torchbox/django-modelcluster/";
    changelog = "https://github.com/wagtail/django-modelcluster/blob/v${version}/CHANGELOG.txt";
    license = licenses.bsd2;
    maintainers = with maintainers; [ desiderius ];
  };
}
