{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  appdirs,
  asgiref,
  attrs,
  black,
  click,
  django,
  djangorestframework,
  entrypoints,
  flake8,
  mccabe,
  mypy,
  mypy-extensions,
  pycodestyle,
  pyflakes,
  pytz,
  sqlparse,
  toml,
  typing-extensions,

  # tests
  pytestCheckHook,
  pytest-django,
}:

buildPythonPackage rec {
  pname = "drf-flex-fields";
  version = "1.0.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "rsinger86";
    repo = "drf-flex-fields";
    tag = version;
    hash = "sha256-+9ToxCEIDpsA+BK8Uk0VueVjoId41/S93+a716EGvCU=";
  };

  patches = [ ./django4-compat.patch ];

  build-system = [ setuptools ];

  nativeCheckInputs = [
    django
    djangorestframework
    pytestCheckHook
    pytest-django
  ];

  preCheck = ''
    export DJANGO_SETTINGS_MODULE=tests.settings
  '';

  meta = {
    changelog = "https://github.com/rsinger86/drf-flex-fields/releases/tag/${src.tag}";
    description = "Dynamically set fields and expand nested resources in Django REST Framework serializers";
    homepage = "https://github.com/rsinger86/drf-flex-fields";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ hexa ];
  };
}
