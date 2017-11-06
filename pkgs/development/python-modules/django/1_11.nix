{ stdenv, buildPythonPackage, fetchurl, substituteAll,
  pythonOlder,
  geos, gdal, pytz
}:

buildPythonPackage rec {
  pname = "Django";
  name = "${pname}-${version}";
  version = "1.11.7";

  disabled = pythonOlder "2.7";

  src = fetchurl {
    url = "http://www.djangoproject.com/m/releases/1.11/${name}.tar.gz";
    sha256 = "16ab3p6jj1da94wkz2b5fb128ycy4826bbsnbabcd3qdaf9f6649";
  };

  patches = [
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
