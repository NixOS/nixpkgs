{ stdenv, buildPythonPackage, fetchurl,
  numpy, django_colorful, pillow, psycopg2,
  pyparsing, django, celery
}:
buildPythonPackage rec {
  version = "0.5";
  pname = "django-raster";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://pypi/d/django-raster/${name}.tar.gz";
    sha256 = "0v1jldb13s4dqq1vaq8ghfv3743jpi9a9n05bqgjm8szlkq8s7ah";
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
