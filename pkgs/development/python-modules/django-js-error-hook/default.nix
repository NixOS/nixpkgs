{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  django,
}:

buildPythonPackage (finalAttrs: {
  pname = "django-js-error-hook";
  version = "1.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "jojax";
    repo = "django-js-error-hook";
    tag = finalAttrs.version;
    hash = "sha256-uUc4UlUmp5czU5awuAK9/eTrNU594T1vXtg0g4g1gDs=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    django
  ];

  pythonImportsCheck = [
    "django_js_error_hook"
  ];

  checkPhase = ''
    runHook preCheck

    python manage.py test --settings=test_settings

    runHook postCheck
  '';

  meta = {
    description = "Simple Django app for logging Javascript client side errors";
    homepage = "https://github.com/jojax/django-js-error-hook";
    changelog = "https://github.com/jojax/django-js-error-hook/blob/${finalAttrs.src.rev}/CHANGELOG";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ eljamm ];
  };
})
