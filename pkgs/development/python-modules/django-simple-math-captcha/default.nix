{
  lib,
  buildPythonPackage,
  django,
  fetchPypi,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "django-simple-math-captcha";
  version = "2.0.1";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-U2OkdU2tRhsiMkZoAy4IQi3Jpe9hHTWVD9Pakqh9GtM=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    django
  ];

  checkPhase = ''
    runHook preCheck
    python -c "
    import sys
    from django.conf import settings
    from django.core.management import execute_from_command_line

    settings.configure(
        DATABASES={'default': {'ENGINE': 'django.db.backends.sqlite3', 'NAME': ':memory:'}},
        INSTALLED_APPS=('simplemathcaptcha', 'test_simplemathcaptcha'),
        SECRET_KEY='foobar',
    )
    execute_from_command_line([
        'manage.py',
        'test',
        'test_simplemathcaptcha.utils_tests',
        'test_simplemathcaptcha.widget_tests',
        'test_simplemathcaptcha.field_tests',
        'test_simplemathcaptcha.form_tests.FormTests.test_form_validation',
    ])
    "
    runHook postCheck
  '';

  pythonImportsCheck = [
    "simplemathcaptcha"
  ];

  meta = {
    description = "Math field/widget captcha for Django forms";
    homepage = "https://github.com/alsoicode/django-simple-math-captcha";
    license = lib.licenses.asl20;
    teams = with lib.teams; [ ngi ];
  };
})
