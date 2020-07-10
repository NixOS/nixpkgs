{ stdenv, buildPythonPackage, fetchPypi, substituteAll,
  pythonOlder,
  geos, gdal, pytz, sqlparse,
  asgiref,
  withGdal ? false
}:

buildPythonPackage rec {
  pname = "Django";
  version = "3.0.8";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "10jm41nlssisny0dwgmi8hnak8020gqb5h4f52gcjwgwlnzgp99i";
  };

  patches = stdenv.lib.optional withGdal
    (substituteAll {
      src = ./3.0-gis-libs.template.patch;
      geos = geos;
      gdal = gdal;
      extension = stdenv.hostPlatform.extensions.sharedLibrary;
    })
  ;

  propagatedBuildInputs = [ pytz sqlparse asgiref ];

  # too complicated to setup
  doCheck = false;

  meta = with stdenv.lib; {
    description = "A high-level Python Web framework";
    homepage = "https://www.djangoproject.com/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ lsix ];
  };
}
