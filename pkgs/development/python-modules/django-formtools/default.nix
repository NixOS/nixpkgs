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
  version = "2.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jazzband";
    repo = "django-formtools";
    tag = finalAttrs.version;
    hash = "sha256-/985+Q2o3BoxxicyDFTYl4m4++d/4Vc+y5qQFpUc9RM=";
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
  ]
  ++ lib.optionals (lib.versionAtLeast django.version "6.1") [
    # https://github.com/jazzband/django-formtools/issues/303
    "test_manipulated_cookie"
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
