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

buildPythonPackage rec {
  pname = "django-huey";
  version = "1.2.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "gaiacoop";
    repo = "django-huey";
    rev = "refs/tags/v${version}";
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

  preCheck = ''
    export DJANGO_SETTINGS_MODULE="tests.settings.base"
  '';

  # Requires django working to import, so don't run pythonImportsCheck

  meta = {
    changelog = "https://github.com/gaiacoop/django-huey/releases/tag/v${version}";
    description = "Django integration for huey task queue that supports multi queue management";
    homepage = "https://github.com/gaiacoop/django-huey";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pyrox0 ];
  };
}
