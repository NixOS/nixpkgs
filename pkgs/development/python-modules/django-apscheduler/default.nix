{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  wheel,
  # dependencies
  django_5,
  apscheduler,
  # tests
  pytestCheckHook,
  pytest-django,
}:

buildPythonPackage rec {
  pname = "django-apscheduler";
  version = "0.7.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jcass77";
    repo = "django-apscheduler";
    rev = "v${version}";
    hash = "sha256-2YSVX4FxE1OfJkSYV9IRKd2scV4BrMA/mBzJARQCX38=";
  };

  build-system = [
    setuptools
    wheel
  ];

  dependencies = [
    django_5
    apscheduler
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-django
  ];

  env.DJANGO_SETTINGS_MODULE = "tests.settings";

  pythonImportsCheck = [
    "django_apscheduler"
  ];

  meta = {
    description = "APScheduler for Django";
    homepage = "https://github.com/jcass77/django-apscheduler";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ happysalada ];
  };
}
