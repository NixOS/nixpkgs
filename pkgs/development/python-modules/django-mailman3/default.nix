{
  lib,
  buildPythonPackage,
  fetchPypi,

  # build-system
  pdm-backend,

  # dependencies
  django-gravatar2,
  django-allauth,
  mailmanclient,
  pytz,

  # tests
  django,
  pytest-django,
  pytestCheckHook,
  nixosTests,
}:

buildPythonPackage rec {
  pname = "django-mailman3";
  version = "1.3.12";
  pyproject = true;

  src = fetchPypi {
    pname = "django_mailman3";
    inherit version;
    hash = "sha256-MnQlT5ElNnStLUKyOXnI7ZDDaBwfp+h9tbOC+cwB0es=";
  };

  build-system = [ pdm-backend ];

  dependencies = [
    django-allauth
    django-gravatar2
    mailmanclient
    pytz
  ];

  nativeCheckInputs = [
    django
    pytest-django
    pytestCheckHook
  ];

  preCheck = ''
    export DJANGO_SETTINGS_MODULE=django_mailman3.tests.settings_test
  '';

  pythonImportsCheck = [ "django_mailman3" ];

  passthru.tests = {
    inherit (nixosTests) mailman;
  };

  meta = with lib; {
    description = "Django library for Mailman UIs";
    homepage = "https://gitlab.com/mailman/django-mailman3";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ qyliss ];
  };
}
