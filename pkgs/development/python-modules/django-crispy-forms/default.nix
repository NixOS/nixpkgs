{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, fetchpatch
# setup.py
, django
# requirements/dev.txt
, pre-commit
, twine
, wheel
# requirements/lint.txt
, black
, flake8
, isort
# flake8-comprehensions
# requirements/testing.txt
, pytestCheckHook
, pytest-cov
, pytest-django
}:

let django-crispy-forms = buildPythonPackage rec {
  pname = "django-crispy-forms";
  version = "1.14.0";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = version;
    hash = "sha256-NZ2lWxsQHc7Qc4HDoWgjJTZ/bJHmjpBf3q1LVLtzA+8=";
  };


  patches = [
    # RuntimeError: Model class source.crispy_forms.tests.forms.CrispyTestModel doesn't declare an explicit app_label and isn't in an application in INSTALLED_APPS.
    # https://github.com/django-crispy-forms/django-crispy-forms/issues/803
    (fetchpatch {
      name = "fix-tests-add-app-label.patch";
      url = "https://github.com/yuuyins/django-crispy-forms/commit/0c358081c2c53170badd7374181c9f277f7a7e2b.patch";
      hash = "sha256-x6ag8MU3GDy9rYpuYO9OgeVnkqjGKwqZRGEN8uOIbQQ=";
    })
  ];

  propagatedBuildInputs = [
    django
    pre-commit
    twine
    wheel
  ];

  checkInputs = [
    # black
    # flake8
    # isort
    # pytest-cov

    pytest-django
    pytestCheckHook
  ];

  pytestFlagsArray = [
  # ds stands for django settings https://pytest-django.readthedocs.io/en/latest/configuring_django.html
    "--ds=crispy_forms.tests.test_settings"
    "crispy_forms/tests/"
  ];

  pythonImportsCheck = [
    "crispy_forms"
  ];

  doCheck = false;

  # FIXME
  # RuntimeError: Conflicting 'crispytestmodel' models in application 'crispy': <class 'crispy_forms.tests.forms.CrispyTestModel'> and <class 'source.crispy_forms.tests.forms.CrispyTestModel
  # https://github.com/django-crispy-forms/django-crispy-forms/issues/803#issuecomment-1279806968
  passthru.tests = {
    default = django-crispy-forms.overridePythonAttrs (oldAttrs: {
      doCheck = true;
    });
  };

  meta = with lib; {
    description = "Strict separation of config from code";
    homepage = "https://django-crispy-forms.readthedocs.io/en/latest/";
    license = licenses.mit;
    maintainers = with maintainers; [ ambroisite ];
  };
}; in django-crispy-forms
