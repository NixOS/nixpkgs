{ lib
, buildPythonPackage
, fetchFromGitHub
, django
, pytestCheckHook
, pytest-django
}:

buildPythonPackage rec {
  pname = "django-crispy-forms";
  version = "1.14.0";

  src = fetchFromGitHub {
    owner = "django-crispy-forms";
    repo = "django-crispy-forms";
    rev = version;
    sha256 = "sha256-NZ2lWxsQHc7Qc4HDoWgjJTZ/bJHmjpBf3q1LVLtzA+8=";
  };

  propagatedBuildInputs = [
    django
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
