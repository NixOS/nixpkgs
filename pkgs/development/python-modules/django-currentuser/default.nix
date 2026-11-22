{
  lib,
  buildPythonPackage,
  django,
  fetchFromGitHub,
  hatchling,
  pyhamcrest,
  python,
  setuptools,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "django-currentuser";
  version = "0.10.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "zsoldosp";
    repo = "django-currentuser";
    tag = "v${version}";
    hash = "sha256-1fg1KRu685hnAyHCOKKqvwU/K8Sm4D7/TRKLBI2tBu0=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [ django ];

  nativeCheckInputs = [ pyhamcrest ];

  preCheck = ''
    DJANGO_SETTINGS_MODULE="settings"
    PYTHONPATH="tests:$PYTHONPATH"
  '';

  checkPhase = ''
    runHook preCheck
    ${python.interpreter} manage.py test testapp
    runHook postCheck
  '';

  meta = {
    description = "Conveniently store reference to request user on thread/db level";
    homepage = "https://github.com/zsoldosp/django-currentuser";
    changelog = "https://github.com/zsoldosp/django-currentuser/#release-notes";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ augustebaum ];
  };
}
