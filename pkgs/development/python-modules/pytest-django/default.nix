{ lib
, buildPythonPackage
, fetchPypi
, django
, setuptools
, setuptools-scm
, django-configurations
, pytest
, pytestCheckHook
}:
buildPythonPackage rec {
  pname = "pytest-django";
  version = "4.7.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ktb9RrHXm1T7awYLuzlCgHM5bOxxfV8uEiqZDUtqpeg=";
  };

  nativeBuildInputs = [
    setuptools
    setuptools-scm
  ];

  buildInputs = [
    pytest
  ];

  propagatedBuildInputs = [
    django
  ];

  nativeCheckInputs = [
    django-configurations
    pytestCheckHook
  ];

  preCheck = ''
    # bring pytest_django_test module into PYTHONPATH
    export PYTHONPATH="$(pwd):$PYTHONPATH"

    # test the lightweight sqlite flavor
    export DJANGO_SETTINGS_MODULE="pytest_django_test.settings_sqlite"
  '';

  disabledTests = [
    # AttributeError: type object 'TestLiveServer' has no attribute '_test_settings_before_run'
    "test_settings_restored"
  ];

  meta = with lib; {
    description = "py.test plugin for testing of Django applications";
    homepage = "https://pytest-django.readthedocs.org/en/latest/";
    license = licenses.bsd3;
  };
}
