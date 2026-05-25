{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  django,
  pytestCheckHook,
  pytest-django,
}:

buildPythonPackage (finalAttrs: {
  pname = "django-override-storage";
  version = "0.3.2";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "danifus";
    repo = "django-override-storage";
    tag = "v${finalAttrs.version}";
    hash = "sha256-hc9Y6jj6AWTOY4R6KTLeWbl3o/lFgAZotzRUBrn6rv8=";
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
  ];

  env.DJANGO_SETTINGS_MODULE = "tests.test_settings";

  pytestFlagsArray = [ "tests/test.py" ];

  pythonImportsCheck = [ "override_storage" ];

  meta = {
    description = "Django test helpers to manage file storage side effects";
    homepage = "https://github.com/danifus/django-override-storage";
    changelog = "https://github.com/danifus/django-override-storage/blob/master/HISTORY.txt";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ philocalyst ];
  };
})
