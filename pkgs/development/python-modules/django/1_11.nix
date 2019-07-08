{ stdenv, buildPythonPackage, fetchurl, substituteAll,
  geos, gdal, pytz,
  withGdal ? false
}:

buildPythonPackage rec {
  pname = "Django";
  version = "1.11.22";

  src = fetchurl {
    url = "https://www.djangoproject.com/m/releases/1.11/${pname}-${version}.tar.gz";
    sha256 = "0if8p7sgbvpy3m8d25pw1x232s14ndd60w5s5d88jl3hl505s3c3";
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

  meta = with stdenv.lib; {
    description = "A high-level Python Web framework";
    homepage = https://www.djangoproject.com/;
    license = licenses.bsd3;
  };
}
