{ lib, stdenv, buildPythonPackage, fetchPypi, substituteAll,
  isPy3k,
  geos, gdal, pytz, sqlparse,
  withGdal ? false
}:

buildPythonPackage rec {
  pname = "django";
  version = "2.2.27";

  disabled = !isPy3k;

  src = fetchPypi {
    pname = "Django";
    inherit version;
    sha256 = "sha256-HuNwRrC/K2HoOzoB0GcyNRbsO28rF81JsTJt1LqdyRM=";
  };

  patches = lib.optional withGdal
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

  meta = with lib; {
    description = "A high-level Python Web framework";
    homepage = "https://www.djangoproject.com/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ georgewhewell ];
  };
}
