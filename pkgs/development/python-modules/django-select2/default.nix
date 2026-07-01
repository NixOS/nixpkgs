{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  flit-scm,
  django,
  django-appconf,
  pytestCheckHook,
  pytest-cov,
  pytest-django,
  selenium,
}:
buildPythonPackage (finalAttrs: {
  pname = "django-select2";
  version = "8.4.8";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "codingjoe";
    repo = "django-select2";
    tag = finalAttrs.version;
    hash = "sha256-bY5pURtJD3gplFqIknAMEDpjtdQN25hLEaqBf+Wme7Q=";
  };

  build-system = [ flit-scm ];

  dependencies = [
    django
    django-appconf
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-cov
    pytest-django
    selenium
  ];

  preInstallCheck = ''
    export PYTHONPATH=$PWD:$PYTHONPATH
    export DJANGO_SETTINGS_MODULE=tests.testapp.settings
  '';

  pythonImportsCheck = [
    "django_select2"
    "django_select2.conf"
    "django_select2.forms"
    "django_select2.views"
    "django_select2.urls"
  ];

  meta = {
    description = "Custom autocomplete fields for Django";
    homepage = "https://github.com/codingjoe/django-select2";
    changelog = "https://github.com/codingjoe/django-select2/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dav-wolff ];
  };
})
