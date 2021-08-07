{ lib, buildPythonPackage, fetchPypi, isPy3k,
  numpy, django_colorful, pillow, psycopg2,
  pyparsing, django, celery, boto3, importlib-metadata
}:
if lib.versionOlder django.version "2.0"
then throw "django-raster requires Django >= 2.0. Consider overiding the python package set to use django_2."
else
buildPythonPackage rec {
  version = "0.8.1";
  pname = "django-raster";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "213758fe96d74be502f69f2620f7666961a85caa0551d14573637315035a9745";
  };

  # Tests require a postgresql + postgis server
  doCheck = false;

  propagatedBuildInputs = [ numpy django_colorful pillow psycopg2
                            pyparsing django celery boto3 importlib-metadata ];

  meta = with lib; {
    description = "Basic raster data integration for Django";
    homepage = "https://github.com/geodesign/django-raster";
    license = licenses.mit;
  };
}
