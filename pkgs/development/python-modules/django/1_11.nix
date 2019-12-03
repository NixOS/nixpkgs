{ stdenv, buildPythonPackage, fetchurl, substituteAll,
  geos, gdal, pytz,
  withGdal ? false
}:

buildPythonPackage rec {
  pname = "Django";
  version = "1.11.26";

  src = fetchurl {
    url = "https://www.djangoproject.com/m/releases/1.11/${pname}-${version}.tar.gz";
    sha256 = "0i7vj8qad0500xz9q0y2yz05zz41ra6yschq87hl7arn4kwbf7c6";
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
