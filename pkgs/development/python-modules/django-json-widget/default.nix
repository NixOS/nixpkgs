{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  django,
  pythonOlder,
  setuptools,
  python,
  pytestCheckHook,
  pytest-django,
}:

buildPythonPackage rec {
  pname = "django-json-widget";
  version = "2.0.3";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "jmrivas86";
    repo = "django-json-widget";
    tag = "v${version}";
    hash = "sha256-11XDmSYJzrjcV3q3P0Kl2WkfoAtuPYzQt5D2ZzRTCCY=";
  };

  build-system = [ setuptools ];

  dependencies = [ django ];

  nativeCheckInputs = [
    pytest-django
    pytestCheckHook
  ];

  preCheck = ''
    export DJANGO_SETTINGS_MODULE=tests.settings
  '';

  pythonImportsCheck = [ "django_json_widget" ];

  meta = {
    description = "Alternative widget that makes it easy to edit the jsonfield field of django";
    homepage = "https://github.com/jmrivas86/django-json-widget";
    changelog = "https://github.com/jmrivas86/django-json-widget/blob/v${version}/CHANGELOG.rst";
    # Contradictory license specifications
    # https://github.com/jmrivas86/django-json-widget/issues/93
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.onny ];
  };
}
