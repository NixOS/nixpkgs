{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  django,
  huey,
  pytestCheckHook,
  pytest-django,
}:

buildPythonPackage (finalAttrs: {
  pname = "django-huey";
  version = "1.2.1";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "gaiacoop";
    repo = "django-huey";
    tag = "v${finalAttrs.version}";
    hash = "sha256-O135Gi3al+IskMLoEegav2v66zNpu8S5DeiguHPla9k=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    django
    huey
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-django
  ];

  pytestFlagsArray = [
    "tests/tests_*.py"
  ];

  env.DJANGO_SETTINGS_MODULE = "tests.settings.base";

  meta = {
    changelog = "https://github.com/gaiacoop/django-huey/releases/tag/v${finalAttrs.version}";
    description = "Django integration for Huey task queue that supports multi-queue management";
    homepage = "https://github.com/gaiacoop/django-huey";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ philocalyst ];
  };
})
