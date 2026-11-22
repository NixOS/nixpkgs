{
  buildPythonPackage,
  django,
  django-debug-toolbar,
  fetchFromGitHub,
  jinja2,
  lib,
  pytest-django,
  pytestCheckHook,
  setuptools-scm,
}:
buildPythonPackage (finalAttrs: {
  pname = "django-flags";
  version = "5.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "cfpb";
    repo = "django-flags";
    tag = finalAttrs.version;
    hash = "sha256-4UOueNXfDouTqpLpG391zcGHTTJ8GfznYmEl33YKdv8=";
  };

  build-system = [
    setuptools-scm
  ];

  dependencies = [
    django
  ];

  preCheck = ''
    export DJANGO_SETTINGS_MODULE=flags.tests.settings
  '';

  pythonImportsCheck = [ "flags" ];

  nativeCheckInputs = [
    django-debug-toolbar
    jinja2
    pytest-django
    pytestCheckHook
  ];

  meta = {
    description = "Feature flags for Django projects";
    homepage = "https://github.com/cfpb/django-flags";
    changelog = "https://github.com/cfpb/django-flags/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.cc0;
    maintainers = with lib.maintainers; [ kurogeek ];
  };
})
