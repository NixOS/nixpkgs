{ stdenv, buildPythonPackage, fetchurl, substituteAll,
  geos, gdal, pytz,
  withGdal ? false
}:

buildPythonPackage rec {
  pname = "Django";
  version = "1.11.28";

  src = fetchurl {
    url = "https://www.djangoproject.com/m/releases/1.11/${pname}-${version}.tar.gz";
    sha256 = "1ss1jyip7mlbfjn27m0j6wx80s8h4ksg6g5annkgwigp8xgy6g5k";
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
  };
}
