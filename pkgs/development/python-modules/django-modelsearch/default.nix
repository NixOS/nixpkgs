{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  django,
  django-tasks,

  # tests
  django-modelcluster,
}:

buildPythonPackage (finalAttrs: {
  pname = "modelsearch";
  version = "1.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "wagtail";
    repo = "django-modelsearch";
    tag = "v${finalAttrs.version}";
    hash = "sha256-zmurjjiJO6A/9XuGsGQcBWRX4NW9xVCFkCVRUk0Ziro=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    django
    django-modelcluster
    django-tasks
  ];

  pythonImportsCheck = [ "modelsearch" ];

  # django.core.exceptions.ImproperlyConfigured: Requested setting INSTALLED_APPS, but settings are not configured.
  # You must either define the environment variable DJANGO_SETTINGS_MODULE or call settings.configure() before accessing settings.
  doCheck = false;

  meta = {
    description = "Index Django Models with Elasticsearch or OpenSearch and query them with the ORM";
    homepage = "https://github.com/wagtail/django-modelsearch";
    changelog = "https://github.com/wagtail/django-modelsearch/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
})
