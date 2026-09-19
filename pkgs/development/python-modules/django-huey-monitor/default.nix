{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
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

buildPythonPackage (finalAttrs: {
  pname = "django-huey-monitor";
  version = "0.10.1";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "boxine";
    repo = "django-huey-monitor";
    tag = "v${finalAttrs.version}";
    hash = "sha256-CG3Y18PIkSWNsgfsLL2qQ3NGlaMIv/slir8GQTE1ygs=";
  };

  postPatch = ''
    substituteInPlace Makefile \
      --replace-fail "/bin/bash" "${lib.getExe bash}"
  '';

  build-system = [
    hatchling
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

  env.DJANGO_SETTINGS_MODULE = "huey_monitor_project.settings.tests";

  disabledTests = [
    # These tests look for dev scripts in the source tree via Makefile, not compatible with sandbox
    "test_code_style"
    "test_manage"
    "test_version"
  ];

  pythonImportsCheck = [ "huey_monitor" ];

  meta = {
    description = "Django based tool for monitoring Huey task queue";
    homepage = "https://github.com/boxine/django-huey-monitor";
    changelog = "https://github.com/boxine/django-huey-monitor/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ philocalyst ];
  };
})
