{ stdenv, buildPythonPackage, fetchurl,
  numpy, django_colorful, pillow, psycopg2,
  pyparsing, django, celery
}:
buildPythonPackage rec {
  version = "0.4";
  pname = "django-raster";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://pypi/d/django-raster/${name}.tar.gz";
    sha256 = "7fd6afa42b07ac51a3873e3d4840325dd3a8a631fdb5b853c76fbbfe59a2b17f";
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
