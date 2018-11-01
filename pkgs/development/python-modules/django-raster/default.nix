{ stdenv, buildPythonPackage, fetchPypi, isPy3k,
  numpy, django_colorful, pillow, psycopg2,
  pyparsing, django, celery, boto3
}:
if stdenv.lib.versionOlder django.version "2.0"
then throw "django-raster requires Django >= 2.0. Consider overiding the python package set to use django_2."
else
buildPythonPackage rec {
  version = "0.6";
  pname = "django-raster";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "9a0f8e71ebeeeb5380c6ca68e027e9de335f43bc15e89dd22e7a470c4eb7aeb8";
  };

  # Tests require a postgresql + postgis server
  doCheck = false;

  propagatedBuildInputs = [ numpy django_colorful pillow psycopg2
                            pyparsing django celery boto3 ];

  meta = with stdenv.lib; {
    description = "Basic raster data integration for Django";
    homepage = https://github.com/geodesign/django-raster;
    license = licenses.mit;
  };
}
