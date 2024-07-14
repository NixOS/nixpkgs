{
  lib,
  buildPythonPackage,
  fetchPypi,
  isPy3k,
  numpy,
  django-colorful,
  pillow,
  psycopg2,
  pyparsing,
  django,
  celery,
  boto3,
  importlib-metadata,
}:

buildPythonPackage rec {
  version = "0.8.1";
  format = "setuptools";
  pname = "django-raster";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ITdY/pbXS+UC9p8mIPdmaWGoXKoFUdFFc2NzFQNal0U=";
  };

  # Tests require a postgresql + postgis server
  doCheck = false;

  propagatedBuildInputs = [
    numpy
    django-colorful
    pillow
    psycopg2
    pyparsing
    django
    celery
    boto3
    importlib-metadata
  ];

  meta = with lib; {
    description = "Basic raster data integration for Django";
    homepage = "https://github.com/geodesign/django-raster";
    license = licenses.mit;
  };
}
