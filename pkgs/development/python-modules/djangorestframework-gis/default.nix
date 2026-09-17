{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  djangorestframework,
  django-filter,
  pytestCheckHook,
  pytest-django,
  psycopg2,
  gdal,
  contexttimer,
}:

buildPythonPackage (finalAttrs: {
  pname = "django-rest-framework-gis";
  version = "1.3.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "openwisp";
    repo = "django-rest-framework-gis";
    tag = finalAttrs.version;
    hash = "sha256-6mSSWlECaoiRUWd7h0t9lJCwrPYSw8gn6ln1ZRULuqw=";
  };

  build-system = [ setuptools ];

  dependencies = [
    djangorestframework
    django-filter
    gdal
  ];

  preCheck = ''
    substituteInPlace tests/settings.py --replace-fail \
      'django_restframework_gis_tests' 'tests.django_restframework_gis_tests'
  '';

  nativeCheckInputs = [
    pytestCheckHook
    pytest-django
    psycopg2
    contexttimer
  ];

  env.GDAL_LIBRARY_PATH = "${gdal}/lib/libgdal.so"; # TODO not working
  env.DJANGO_SETTINGS_MODULE = "tests.settings";

  # pname is different from python package name
  dontCheckPythonMetadata = true;
  pythonImportsCheck = [ "rest_framework_gis" ];

  meta = {
    description = "Geographic add-ons for Django REST Framework";
    homepage = "https://github.com/openwisp/django-rest-framework-gis";
    changelog = "https://github.com/openwisp/django-rest-framework-gis/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ felbinger ];
  };
})
