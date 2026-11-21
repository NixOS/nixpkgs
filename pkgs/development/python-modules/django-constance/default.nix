{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  django,
  pytest-django,
  pytestCheckHook,
  redis,
  setuptools,
  setuptools-scm,
}:

buildPythonPackage (finalAttrs: {
  pname = "django-constance";
  version = "4.5.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jazzband";
    repo = "django-constance";
    tag = finalAttrs.version;
    hash = "sha256-y8Z1cMUhfFxRU5dgDlaTzOS5nP2DOjhrwmCTsV7blyo=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    django
  ];

  optional-dependencies = {
    redis = [
      redis
    ];
  };

  nativeCheckInputs = [
    pytestCheckHook
    pytest-django
    redis
  ];

  env.DJANGO_SETTINGS_MODULE = "tests.settings";

  pythonImportsCheck = [
    "constance"
  ];

  meta = {
    description = "Dynamic Django settings";
    homepage = "https://github.com/jazzband/django-constance";
    license = lib.licenses.bsd3;
    teams = with lib.teams; [ ngi ];
  };
})
