{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  django,
  setuptools,
  python,
  pytestCheckHook,
  pytest-django,
}:

buildPythonPackage rec {
  pname = "django-json-widget";
  version = "2.1.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jmrivas86";
    repo = "django-json-widget";
    tag = "v${version}";
    hash = "sha256-AABJHWoEIcyJyRHv3sp1d1l6ZByF8Q5h+xEHJe/4uC0=";
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
    changelog = "https://github.com/jmrivas86/django-json-widget/blob/${src.tag}/CHANGELOG.rst";
    # Contradictory license specifications
    # https://github.com/jmrivas86/django-json-widget/issues/93
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.onny ];
  };
}
