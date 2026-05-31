{
  lib,
  buildPythonPackage,
  django,
  fetchFromGitHub,
  setuptools,
  setuptools-scm,
  pytestCheckHook,
  pytest-django,
}:

buildPythonPackage (finalAttrs: {
  pname = "django-formtools";
  version = "2.6.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jazzband";
    repo = "django-formtools";
    tag = finalAttrs.version;
    hash = "sha256-cg6bl2KJL2aOES7vWqrR25Bd6t9vWGTZLWtbMUhkCkg=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [ django ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-django
  ];

  preCheck = ''
    export DJANGO_SETTINGS_MODULE=tests.settings
  '';

  disabledTests = [
    # mismatch between test collection of django and pytest-django
    "TestStorage"
  ];

  pythonImportsCheck = [ "formtools" ];

  meta = {
    description = "High-level abstractions for Django forms";
    homepage = "https://github.com/jazzband/django-formtools";
    changelog = "https://github.com/jazzband/django-formtools/blob/${finalAttrs.src.tag}/docs/changelog.rst";
    license = lib.licenses.bsd3;
    maintainers = [ ];
  };
})
