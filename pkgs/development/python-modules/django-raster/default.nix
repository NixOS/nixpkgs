{ stdenv, buildPythonPackage, fetchurl,
  numpy, django_colorful, pillow, psycopg2,
  pyparsing, django, celery
}:
buildPythonPackage rec {
  version = "0.6";
  pname = "django-raster";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://pypi/d/django-raster/${name}.tar.gz";
    sha256 = "9a0f8e71ebeeeb5380c6ca68e027e9de335f43bc15e89dd22e7a470c4eb7aeb8";
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
