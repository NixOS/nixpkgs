{ stdenv, buildPythonPackage, fetchPypi, substituteAll,
  isPy3k,
  geos, gdal, pytz,
  withGdal ? false
}:

buildPythonPackage rec {
  pname = "Django";
  version = "2.1.14";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "d9159141fc354c4c28cc2b2586d55ba6d5e1531f5470218bb56a75be03d67398";
  };

  patches = stdenv.lib.optionals withGdal [
    (substituteAll {
      src = ./1.10-gis-libs.template.patch;
      geos = geos;
      gdal = gdal;
      extension = stdenv.hostPlatform.extensions.sharedLibrary;
    })
  ];

  propagatedBuildInputs = [ pytz ];

  # too complicated to setup
  doCheck = false;

  meta = with stdenv.lib; {
    description = "A high-level Python Web framework";
    homepage = https://www.djangoproject.com/;
    license = licenses.bsd3;
    maintainers = with maintainers; [ georgewhewell ];
  };
}
