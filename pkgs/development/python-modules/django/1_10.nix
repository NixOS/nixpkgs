{ stdenv, buildPythonPackage, fetchurl, substituteAll,
  pythonOlder,
  geos, gdal
}:
buildPythonPackage rec {
  name = "Django-${version}";
  version = "1.10.6";
  disabled = pythonOlder "2.7";

  src = fetchurl {
    url = "http://www.djangoproject.com/m/releases/1.10/${name}.tar.gz";
    sha256 = "0q9c7hx720vc0jzq4xlxwhnxmmm8kh0qsqj3l46m29mi98jvwvks";
  };

  patches = [
    (substituteAll {
      src = ./1.10-gis-libs.template.patch;
      geos = geos;
      gdal = gdal;
    })
  ];

  # patch only $out/bin to avoid problems with starter templates (see #3134)
  postFixup = ''
    wrapPythonProgramsIn $out/bin "$out $pythonPath"
  '';

  # too complicated to setup
  doCheck = false;

  meta = {
    description = "A high-level Python Web framework";
    homepage = https://www.djangoproject.com/;
  };
}
