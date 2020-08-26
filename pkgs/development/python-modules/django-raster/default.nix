{ stdenv, buildPythonPackage, fetchPypi, isPy3k,
  numpy, django_colorful, pillow, psycopg2,
  pyparsing, django, celery, boto3, importlib-metadata
}:
if stdenv.lib.versionOlder django.version "2.0"
then throw "django-raster requires Django >= 2.0. Consider overiding the python package set to use django_2."
else
buildPythonPackage rec {
  version = "0.8";
  pname = "django-raster";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "9417d8a17930dffee4719f79a38c6ab5d20ac7145d4edf88df0abcb5a360de51";
  };

  # Tests require a postgresql + postgis server
  doCheck = false;

  propagatedBuildInputs = [ numpy django_colorful pillow psycopg2
                            pyparsing django celery boto3 importlib-metadata ];

  meta = with stdenv.lib; {
    description = "Basic raster data integration for Django";
    homepage = "https://github.com/geodesign/django-raster";
    license = licenses.mit;
  };
}
