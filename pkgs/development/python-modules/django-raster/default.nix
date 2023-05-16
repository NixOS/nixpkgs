{ lib, buildPythonPackage, fetchPypi, isPy3k,
<<<<<<< HEAD
  numpy, django-colorful, pillow, psycopg2,
=======
  numpy, django_colorful, pillow, psycopg2,
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  pyparsing, django, celery, boto3, importlib-metadata
}:

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

<<<<<<< HEAD
  propagatedBuildInputs = [ numpy django-colorful pillow psycopg2
=======
  propagatedBuildInputs = [ numpy django_colorful pillow psycopg2
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
                            pyparsing django celery boto3 importlib-metadata ];

  meta = with lib; {
    description = "Basic raster data integration for Django";
    homepage = "https://github.com/geodesign/django-raster";
    license = licenses.mit;
  };
}
