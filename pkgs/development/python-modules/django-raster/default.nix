{ stdenv, buildPythonPackage, fetchurl,
  numpy, django_colorful, pillow, psycopg2,
  pyparsing, django, celery
}:
buildPythonPackage rec {
  name = "django-raster-${version}";
  version = "0.3.1";

  src = fetchurl {
    url = "mirror://pypi/d/django-raster/${name}.tar.gz";
    sha256 = "1hsrkvybak1adn9d9qdw7hx3rcxsbzas4ixwll6vrjkrizgfihk3";
  };

  # Tests require a postgresql + postgis server
  doCheck = false;

  propagatedBuildInputs = [ numpy django_colorful pillow psycopg2
                            pyparsing django celery ];

  meta = with stdenv.lib; {
    description = "Basic raster data integration for Django";
    homepage = https://github.com/geodesign/django-raster;
    license = licenses.mit;
  };
}
