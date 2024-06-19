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
  version = "2.1";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "django-crispy-forms";
    repo = "django-crispy-forms";
    rev = "refs/tags/${version}";
    hash = "sha256-UQ5m0JWir20TdLgS+DVVLcMBlIEIfmzv8pkMJtaC0LA=";
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

  pytestFlagsArray = [
    "--ds=crispy_forms.tests.test_settings"
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
