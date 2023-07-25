{ lib
, buildPythonPackage
, fetchFromGitHub

# build-system
, setuptools

# dependencies
, beautifulsoup4

# tests
, django
, python
}:

buildPythonPackage rec {
  pname = "django-bootstrap4";
  version = "23.1";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "zostera";
    repo = "django-bootstrap4";
    rev = "v${version}";
    hash = "sha256-55pfUPwxDzpDn4stMEPvrQAexs+goN5SKFvwSR3J4aM=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    beautifulsoup4
  ];

  pythonImportsCheck = [
    "bootstrap4"
  ];

  nativeCheckInputs = [
    (django.override { withGdal = true; })
  ];

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
