{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,
  wheel,

  # dependencies
  django-appconf,
  dnspython,
  pillow,

  # tests
  pytestCheckHook,
  django,
  coverage,
  python-magic,
}:

buildPythonPackage (finalAttrs: {
  pname = "django-avatar";
  version = "8.0.1";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "jazzband";
    repo = "django-avatar";
    tag = "v${finalAttrs.version}";
    hash = "sha256-g4H3Q1eMWMDskG0FdbnaYAolXKpewncD91xmzV7AJ9s=";
  };

  build-system = [
    setuptools
    wheel
  ];

  dependencies = [
    django-appconf
    dnspython
    pillow
  ];

  pythonImportsCheck = [
    "avatar"
  ];

  nativeCheckInputs = [
    coverage
    django
    pytestCheckHook
    python-magic
  ];

  checkPhase = ''
    runHook preCheck

    export DJANGO_SETTINGS_MODULE=tests.settings
    python -m coverage run --source=avatar -m django test tests

    runHook postCheck
  '';

  meta = {
    description = "Django app for handling user avatars";
    homepage = "https://github.com/jazzband/django-avatar";
    changelog = "https://github.com/jazzband/django-avatar/blob/${finalAttrs.src.rev}/CHANGELOG.rst";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ eljamm ];
  };
})
