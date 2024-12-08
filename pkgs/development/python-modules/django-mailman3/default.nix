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
  version = "1.3.15";
  pyproject = true;

  src = fetchPypi {
    pname = "django_mailman3";
    inherit version;
    hash = "sha256-+ZFrJpy5xdW6Yde/XEvxoAN8+TSQdiI0PfjZ7bHG0Rs=";
  };

  pythonRelaxDeps = [ "django-allauth" ];

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
