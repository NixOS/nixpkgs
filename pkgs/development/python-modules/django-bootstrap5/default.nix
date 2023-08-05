{ lib
, beautifulsoup4
, buildPythonPackage
, django
, fetchFromGitHub
, pillow
, pythonOlder
, python
, setuptools
, hatchling
}:

buildPythonPackage rec {
  pname = "django-bootstrap5";
  version = "23.3";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "zostera";
    repo = "django-bootstrap5";
    rev = "v${version}";
    hash = "sha256-FIwDyZ5I/FSaEiQKRfanzAGij86u8y85Wal0B4TrI7c=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace "\"Framework :: Django :: 4.2\"," ""
  '';

  nativeBuildInputs = [
    setuptools
    hatchling
  ];

  propagatedBuildInputs = [
    django
    beautifulsoup4
    pillow
  ];

  # require internet connection
  doCheck = false;

  pythonImportsCheck = [
    "django_bootstrap5"
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
    description = "Bootstrap 5 integration with Django";
    homepage = "https://github.com/zostera/django-bootstrap5";
    changelog = "https://github.com/zostera/django-bootstrap5/blob/${src.rev}/CHANGELOG.md";
    license = licenses.bsd3;
    maintainers = with maintainers; [ derdennisop ];
  };
}
