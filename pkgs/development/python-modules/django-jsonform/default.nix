{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  django,
  pytestCheckHook,
  pytest-django,
  psycopg2,
}:

buildPythonPackage (finalAttrs: {
  pname = "django-jsonform";
  version = "2.23.1";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "bhch";
    repo = "django-jsonform";
    tag = "v${finalAttrs.version}";
    hash = "sha256-QWs9/i1sWvfXTFxvsI4LmTLNcOmzb6OA20HL9gH2qUs=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    django
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-django
    psycopg2
  ];

  env.DJANGO_SETTINGS_MODULE = "tests.django_settings";

  pythonImportsCheck = [ "django_jsonform" ];

  meta = {
    changelog = "https://github.com/bhch/django-jsonform/releases/tag/v${finalAttrs.version}";
    description = "User-friendly JSON editing form for Django admin";
    homepage = "https://github.com/bhch/django-jsonform";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ philocalyst ];
  };
})
