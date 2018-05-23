{ stdenv, buildPythonPackage, fetchurl, substituteAll,
  pythonOlder,
  geos, gdal, pytz,
  withGdal ? false
}:

buildPythonPackage rec {
  pname = "Django";
  version = "1.11.13";

  disabled = pythonOlder "2.7";

  src = fetchurl {
    url = "http://www.djangoproject.com/m/releases/1.11/${pname}-${version}.tar.gz";
    sha256 = "19d4c1rlbhmbvbxvskvqjb2aw4dnf2cqi1hhdh11ykdy1a7gxba6";
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
