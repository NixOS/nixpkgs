{ lib
, buildPythonPackage
, fetchurl
, django
, setuptools-scm
, elasticsearch-dsl
, twine
, sphinx
, coverage
, mock
, flake8
, tox
, pillow
}:

buildPythonPackage rec {
  pname = "django-elasticsearch-dsl";
  version = "7.2.2";

  src = fetchurl {
    url = "https://github.com/django-es/django-elasticsearch-dsl/archive/refs/tags/${version}.tar.gz";
    sha256 = "sha256-/aZchTj4EM+QH42yQrPleo4cKu185DvYB2T/9k9M5/s=";
  };

  buildInputs = [ setuptools-scm ];

  propagatedBuildInputs = [ django elasticsearch-dsl twine sphinx ];

  # django.core.exceptions.ImproperlyConfigured: Requested settings, but settings are not configured. You must either define the environment variable DJANGO_SETTINGS_MODULE or call settings.configure() before accessing settings.
  doCheck = false;

  checkInputs = [
    django
    mock
    coverage
    flake8
    tox
    pillow
  ];

  meta = with lib; {
    description = "A thin wrapper around elasticsearch-dsl-py that allows indexing of django models in elasticsearch.";
    homepage = "https://github.com/django-es/django-elasticsearch-dsl";
    license = licenses.asl20;
    maintainers = with maintainers; [];
  };
}
