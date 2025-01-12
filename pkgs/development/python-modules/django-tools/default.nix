{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools-scm,
  django,
  colorlog,
  gunicorn,
  icdiff,
  pprintpp,
  bleach,
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

buildPythonPackage rec {
  pname = "django-tools";
  version = "0.56.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jedie";
    repo = "django-tools";
    rev = "refs/tags/v${version}";
    hash = "sha256-9f7rH4SH8b7NA+O8/DnconlrcgS+GEd68dBQLQqB0T4=";
  };

  build-system = [
    setuptools-scm
  ];

  dependencies = [
    django
    colorlog
    gunicorn
    icdiff
    pprintpp
    bleach
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

  preCheck = ''
    export DJANGO_SETTINGS_MODULE="django_tools_project.settings.tests"
    export HOME=$(mktemp -d)
  '';

  disabledTests = [
    # Tries to find binaries or scripts in non-existant directories
    "test_code_style"
    "test_version"
    "test_manage"

    # Wants access to /etc
    "test_doctests"

    # Tries to install packages, which requires internet
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
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ pyrox0 ];
  };
}
