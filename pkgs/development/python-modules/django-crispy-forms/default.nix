{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  django,
  setuptools,
  pytestCheckHook,
  pytest-django,
}:

buildPythonPackage rec {
  pname = "django-crispy-forms";
  version = "2.5";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "django-crispy-forms";
    repo = "django-crispy-forms";
    tag = version;
    hash = "sha256-UZw860dOmQOAHcOPn5JO5OPe0kei4Mivy5FTh25Zo1s=";
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

  meta = with lib; {
    description = "Best way to have DRY Django forms";
    homepage = "https://django-crispy-forms.readthedocs.io/en/latest/";
    license = licenses.mit;
    maintainers = with maintainers; [ ambroisie ];
  };
}
