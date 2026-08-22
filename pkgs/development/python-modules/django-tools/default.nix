{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  django,
  colorlog,
  gunicorn,
  icdiff,
  pprintpp,
  bleach,
  django-debug-toolbar,
  bx-py-utils,
  bx-django-utils,
  pytestCheckHook,
  pytest-django,
  django-parler,
  beautifulsoup4,
  pillow,
  cli-base-utilities,
  manage-django-project,
  pip,
  pip-tools,
  model-bakery,
  django-override-storage,
  typeguard,
}:

buildPythonPackage (finalAttrs: {
  pname = "django-tools";
  version = "0.58.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "jedie";
    repo = "django-tools";
    tag = "v${finalAttrs.version}";
    hash = "sha256-vc3QsA4wsMXxvkNCGAPJf+TkCt/6gFqYtHxwZEf/fWA=";
  };

  build-system = [
    hatchling
  ];

  dependencies = [
    django
    colorlog
    gunicorn
    icdiff
    pprintpp
    bleach
    django-debug-toolbar
    bx-py-utils
    bx-django-utils
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-django
    django-parler
    beautifulsoup4
    pillow
    cli-base-utilities
    manage-django-project
    pip
    pip-tools
    model-bakery
    django-override-storage
    typeguard
  ];

  env = {
    DJANGO_SETTINGS_MODULE = "django_tools_project.settings.tests";
    HOME = "/tmp";
  };

  disabledTests = [
    # Tries to find dev scripts in non-existent directories via Makefile
    "test_code_style"
    "test_version"
    "test_manage"
    # Tries to access /etc which is unavailable in the Nix sandbox
    "test_doctests"
    # Tries to install packages from the internet
    "test_database_info"
    "test_run_testserver_invalid_addr"
    "test_run_testserver_help"
    "test_nice_diffsettings"
    "test_help"
    "test_excepted_exit_code"
  ];

  pythonImportsCheck = [ "django_tools" ];

  meta = {
    description = "Miscellaneous tools for Django based projects";
    homepage = "https://github.com/jedie/django-tools";
    changelog = "https://github.com/jedie/django-tools/blob/main/README.md";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ philocalyst ];
  };
})
