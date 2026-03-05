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
  django-taggit,
  dj-database-url,
  psycopg,
  pytestCheckHook,
  pytest-django,
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
    django-tasks
  ];

  pythonImportsCheck = [ "modelsearch" ];

  nativeCheckInputs = [
    dj-database-url
    psycopg
    django-modelcluster
    django-taggit
    pytest-django
    pytestCheckHook
  ];

  preCheck = ''
    export DJANGO_SETTINGS_MODULE=modelsearch.test.settings
    export SEARCH_BACKEND=db
  '';

  meta = {
    description = "Index Django Models with Elasticsearch or OpenSearch and query them with the ORM";
    homepage = "https://github.com/wagtail/django-modelsearch";
    changelog = "https://github.com/wagtail/django-modelsearch/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
})
