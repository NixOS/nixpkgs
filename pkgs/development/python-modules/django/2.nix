{ lib, stdenv, buildPythonPackage, fetchPypi, substituteAll,
  isPy3k,
  geos, gdal, pytz, sqlparse,
  withGdal ? false
}:

buildPythonPackage rec {
  pname = "Django";
  version = "2.2.28";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-AgC2V6+/G8CAA4Rd3aBTx2QbmySVHlKs1R9qvaM6dBM=";
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
