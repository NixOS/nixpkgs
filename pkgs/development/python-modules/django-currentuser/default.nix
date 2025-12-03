{
  lib,
  buildPythonPackage,
  django,
  fetchFromGitHub,
  hatchling,
  pyhamcrest,
  python,
  pythonOlder,
  setuptools,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "django-currentuser";
  version = "0.9.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "zsoldosp";
    repo = "django-currentuser";
    tag = "v${version}";
    hash = "sha256-pfgsVsWM/aehZZAQzjL1fdsqWlfnquOniu76UoLPREI=";
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

  meta = with lib; {
    description = "Conveniently store reference to request user on thread/db level";
    homepage = "https://github.com/zsoldosp/django-currentuser";
    changelog = "https://github.com/zsoldosp/django-currentuser/#release-notes";
    license = licenses.bsd3;
    maintainers = with maintainers; [ augustebaum ];
  };
}
