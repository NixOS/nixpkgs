{ stdenv, buildPythonPackage, fetchPypi, substituteAll,
  isPy3k,
  geos, gdal, pytz,
  withGdal ? false
}:

buildPythonPackage rec {
  pname = "Django";
  name = "${pname}-${version}";
  version = "2.0.5";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "71d1a584bb4ad2b4f933d07d02c716755c1394feaac1ce61ce37843ac5401092";
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
    maintainers = with maintainers; [ georgewhewell ];
  };
}
