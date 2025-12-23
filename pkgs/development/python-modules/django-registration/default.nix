{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pdm-backend,
  confusable-homoglyphs,
  coverage,
  django,
}:

buildPythonPackage rec {
  pname = "django-registration";
  version = "5.2.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ubernostrum";
    repo = "django-registration";
    tag = version;
    hash = "sha256-k7r4g+iCdAwAUNQdbtxzS5kqgAavEBAJERSWgXvbXqg=";
  };

  build-system = [ pdm-backend ];

  dependencies = [
    confusable-homoglyphs
  ];

  nativeCheckInputs = [
    coverage
    django
  ];

  installCheckPhase = ''
    runHook preInstallCheck

    DJANGO_SETTINGS_MODULE=tests.settings python -m coverage run --source django_registration runtests.py

    runHook postInstallCheck
  '';

  pythonImportsCheck = [ "django_registration" ];

  meta = {
    changelog = "https://github.com/ubernostrum/django-registration/blob/${version}/docs/changelog.rst";
    description = "User registration app for Django";
    homepage = "https://django-registration.readthedocs.io/en/${version}/";
    downloadPage = "https://github.com/ubernostrum/django-registration";
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.l0b0 ];
  };
}
