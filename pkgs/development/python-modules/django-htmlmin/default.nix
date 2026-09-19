{
  lib,
  argparse,
  beautifulsoup4,
  buildPythonPackage,
  django,
  fetchFromGitHub,
  html5lib,
  pytest-django,
  pytestCheckHook,
  setuptools,
  six,
}:

buildPythonPackage rec {
  pname = "django-htmlmin";
  version = "0.11.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "cobrateam";
    repo = "django-htmlmin";
    tag = version;
    hash = "sha256-1HtTIvB3UKFW/w5fomcRbOwLFAYVKe8Bpfjhqkbdx6M=";
  };

  postPatch = ''
    substituteInPlace htmlmin/tests/pico_django.py \
      --replace-fail "from django.conf.urls import url" "from django.urls import re_path as url"

    substituteInPlace htmlmin/tests/test_decorator.py \
      --replace-fail "assertEquals" "assertEqual"
  '';

  build-system = [ setuptools ];

  dependencies = [
    argparse
    django
    beautifulsoup4
    html5lib
    six
  ];

  nativeCheckInputs = [
    pytest-django
    pytestCheckHook
  ];

  env = {
    DJANGO_SETTINGS_MODULE = "htmlmin.tests.mock_settings";
  };

  pythonImportsCheck = [ "htmlmin" ];

  meta = {
    description = "HTML minifier for Python frameworks";
    homepage = "https://github.com/cobrateam/django-htmlmin/";
    changelog = "https://github.com/cobrateam/django-htmlmin/tag/${src.tag}";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ SuperSandro2000 ];
  };
}
