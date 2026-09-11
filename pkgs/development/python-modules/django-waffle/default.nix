{
  buildPythonPackage,
  fetchFromGitHub,
  django,
  lib,
  setuptools,
  pytestCheckHook,
  pytest-django,
}:

buildPythonPackage (finalAttrs: {
  pname = "django-waffle";
  version = "5.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "django-waffle";
    repo = "django-waffle";
    tag = "v${finalAttrs.version}";
    hash = "sha256-wirB2Y4iONmAMVt9o8aTkeB1WQzcvktQOAMEeXMM1x8=";
  };

  patches = [
    # Middleware object requires a request -> response callable
    ./middleware-compat.patch
  ];

  build-system = [ setuptools ];

  dependencies = [ django ];

  nativeCheckInputs = [
    pytest-django
    pytestCheckHook
  ];

  preCheck = ''
    export DJANGO_SETTINGS_MODULE=test_settings
  '';

  meta = {
    changelog = "https://github.com/django-waffle/django-waffle/releases/tag/${finalAttrs.src.tag}";
    description = "Feature flipper for Django";
    homepage = "https://waffle.readthedocs.io/en/stable/";
    maintainers = [ lib.maintainers.ma27 ];
    license = lib.licenses.bsd3;
  };
})
