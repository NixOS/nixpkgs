{ lib
, buildPythonPackage
, fetchFromGitHub
, django
, setuptools
, pytestCheckHook
, pytest-django
}:

buildPythonPackage rec {
  pname = "django-crispy-forms";
  version = "2.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "django-crispy-forms";
    repo = "django-crispy-forms";
    rev = "refs/tags/${version}";
    hash = "sha256-oxOW7gFpjUehWGeqZZjhPwptX0Gpgj5lP0lw0zkYGuE=";
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
    description = "The best way to have DRY Django forms.";
    homepage = "https://django-crispy-forms.readthedocs.io/en/latest/";
    license = licenses.mit;
    maintainers = with maintainers; [ ambroisie ];
  };
}
