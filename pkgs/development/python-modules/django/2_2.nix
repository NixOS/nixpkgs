{ stdenv, buildPythonPackage, fetchPypi, substituteAll,
  isPy3k,
  geos, gdal, pytz, sqlparse,
  withGdal ? false
}:

buildPythonPackage rec {
  pname = "Django";
  version = "2.2.5";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "0mpxmckd1mah0yrp6n8vjk6mq7hxf6d5xcbk6rcmi6z572h0mdyy";
  };

  patches = stdenv.lib.optional withGdal
    (substituteAll {
      src = ./1.10-gis-libs.template.patch;
      geos = geos;
      gdal = gdal;
      extension = stdenv.hostPlatform.extensions.sharedLibrary;
    })
  ;

  propagatedBuildInputs = [ pytz sqlparse ];

  # too complicated to setup
  doCheck = false;

  meta = with stdenv.lib; {
    description = "A high-level Python Web framework";
    homepage = https://www.djangoproject.com/;
    license = licenses.bsd3;
    maintainers = with maintainers; [ georgewhewell lsix ];
  };
}
