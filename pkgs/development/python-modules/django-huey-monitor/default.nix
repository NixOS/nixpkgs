{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools-scm,
  django,
  huey,
  bx-django-utils,
  bx-py-utils,
  pytestCheckHook,
  pytest-django,
  model-bakery,
  packaging,
  typeguard,
  colorlog,
  manage-django-project,
  bash,
}:

buildPythonPackage rec {
  pname = "django-huey-monitor";
  version = "0.9.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "boxine";
    repo = "django-huey-monitor";
    rev = "refs/tags/v${version}";
    hash = "sha256-U5Nm5YdrxmVBovYCLCEim5x8C4VuE+/J+5M5JT6upc0=";
  };

  postPatch = ''
    substituteInPlace Makefile \
      --replace-fail "/bin/bash" "${lib.getExe bash}"
  '';

  build-system = [
    setuptools-scm
  ];

  dependencies = [
    django
    bx-django-utils
    bx-py-utils
    huey
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-django
    model-bakery
    packaging
    typeguard
    colorlog
    manage-django-project
  ];

  preCheck = ''
    export DJANGO_SETTINGS_MODULE="huey_monitor_project.settings.tests"
  '';

  disabledTests = [
    # Look for scripts and binaries in an incompatible way
    "test_code_style"
    "test_manage"
    "test_version"
  ];

  pythonImportsCheck = [ "huey_monitor" ];

  meta = {
    description = "Django based tool for monitoring huey task queue";
    homepage = "https://github.com/boxine/django-huey-monitor";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ pyrox0 ];
  };
}
