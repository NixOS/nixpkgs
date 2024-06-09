{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,
  setuptools-scm,

  # non-propagates
  django,

  # dependencies
  beautifulsoup4,

  # tests
  python,
}:

buildPythonPackage rec {
  pname = "django-bootstrap4";
  version = "24.3";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "zostera";
    repo = "django-bootstrap4";
    rev = "refs/tags/v${version}";
    hash = "sha256-sZY/0f1PbYQu9fN65H6H7xLvsdE9AXK0cMt9TyAKuUw=";
  };

  nativeBuildInputs = [
    setuptools
    setuptools-scm
  ];

  propagatedBuildInputs = [ beautifulsoup4 ];

  pythonImportsCheck = [ "bootstrap4" ];

  nativeCheckInputs = [ (django.override { withGdal = true; }) ];

  checkPhase = ''
    runHook preCheck
    ${python.interpreter} manage.py test -v1 --noinput
    runHook postCheck
  '';

  meta = with lib; {
    description = "Bootstrap 4 integration with Django";
    homepage = "https://github.com/zostera/django-bootstrap4";
    changelog = "https://github.com/zostera/django-bootstrap4/blob/${src.rev}/CHANGELOG.md";
    license = licenses.bsd3;
    maintainers = with maintainers; [ hexa ];
  };
}
