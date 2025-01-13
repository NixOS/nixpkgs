{
  lib,
  buildPythonPackage,
  confusable-homoglyphs,
  coverage,
  django,
  fetchPypi,
  nix-update-script,
  nox,
  pdm-backend,
  pythonAtLeast,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "django-registration";
  version = "5.1.0";
  pyproject = true;

  disabled = pythonOlder "3.9" || pythonAtLeast "3.13";

  src = fetchPypi {
    pname = "django_registration";
    inherit version;
    hash = "sha256-5ksLHSSIb8dAEihiYw7AC4wv/Uq20OCpvO2HA3TRQ2s=";
  };

  build-system = [ pdm-backend ];

  dependencies = [
    confusable-homoglyphs
    django
  ];

  nativeCheckInputs = [
    coverage
    django
    nox
  ];

  check = false;

  pythonImportsCheck = [ "django_registration" ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    changelog = "https://github.com/ubernostrum/django-registration/blob/trunk/docs/changelog.rst";
    description = "User registration app for Django";
    downloadPage = "https://github.com/ubernostrum/django-registration";
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.l0b0 ];
  };
}
