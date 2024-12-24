{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  setuptools-scm,
  django,
  django-ipware,
  pytestCheckHook,
  pytest-cov-stub,
  pytest-django,
}:

buildPythonPackage rec {
  pname = "django-axes";
  version = "7.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jazzband";
    repo = "django-axes";
    rev = "refs/tags/${version}";
    hash = "sha256-Ci1+xC0MQKPxev4P70QnU+TSEAxiqYwIIOlqN1Lyido=";
  };

  build-system = [ setuptools-scm ];

  dependencies = [ django ];

  nativeCheckInputs = [
    django-ipware
    pytestCheckHook
    pytest-cov-stub
    pytest-django
  ];

  env.DJANGO_SETTINGS_MODULE = "tests.settings";

  pythonImportsCheck = [ "axes" ];

  meta = {
    description = "Keep track of failed login attempts in Django-powered sites";
    homepage = "https://github.com/jazzband/django-axes";
    maintainers = with lib.maintainers; [ sikmir ];
    license = lib.licenses.mit;
  };
}
