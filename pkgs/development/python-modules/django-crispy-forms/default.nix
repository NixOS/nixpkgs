{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  django,
  setuptools,
  pytestCheckHook,
  pytest-django,
}:

buildPythonPackage (finalAttrs: {
  pname = "django-crispy-forms";
  version = "2.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "django-crispy-forms";
    repo = "django-crispy-forms";
    tag = finalAttrs.version;
    hash = "sha256-Fi4g1jAMUZP3th22TS/n8nIKz8yKgJDj4oJq0+5+W4I=";
  };

  propagatedBuildInputs = [
    django
    setuptools
  ];

  # FIXME: RuntimeError: Model class source.crispy_forms.tests.forms.CrispyTestModel doesn't declare an explicit app_label and isn't in an application in INSTALLED_APPS.
  doCheck = false;

  nativeCheckInputs = [
    pytest-django
    pytestCheckHook
  ];

  pytestFlags = [
    "--ds=crispy_forms.tests.test_settings"
  ];

  enabledTestPaths = [
    "crispy_forms/tests/"
  ];

  pythonImportsCheck = [ "crispy_forms" ];

  meta = {
    description = "Best way to have DRY Django forms";
    homepage = "https://django-crispy-forms.readthedocs.io/en/latest/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ambroisie ];
  };
})
