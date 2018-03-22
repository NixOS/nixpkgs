{ stdenv, buildPythonPackage, fetchurl, substituteAll,
  pythonOlder,
  geos, gdal, pytz,
  withGdal ? false
}:

buildPythonPackage rec {
  pname = "Django";
  name = "${pname}-${version}";
  version = "1.11.9";

  disabled = pythonOlder "2.7";

  src = fetchurl {
    url = "http://www.djangoproject.com/m/releases/1.11/${name}.tar.gz";
    sha256 = "0d0hh9sh2rwazi7z2lnqvz1424bq6ps6c5h6ss04klp14agi4g9m";
  };

  patches = stdenv.lib.optionals withGdal [
    (substituteAll {
      src = ./1.10-gis-libs.template.patch;
      geos = geos;
      gdal = gdal;
      extension = stdenv.hostPlatform.extensions.sharedLibrary;
    })
  ];

  # patch only $out/bin to avoid problems with starter templates (see #3134)
  postFixup = ''
    wrapPythonProgramsIn $out/bin "$out $pythonPath"
  '';

  propagatedBuildInputs = [ pytz ];

  # too complicated to setup
  doCheck = false;

  meta = {
    description = "A high-level Python Web framework";
    homepage = https://www.djangoproject.com/;
  };
}
