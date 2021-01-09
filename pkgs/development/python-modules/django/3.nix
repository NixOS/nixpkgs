{ stdenv
, buildPythonPackage
, fetchPypi
, substituteAll
, geos
, gdal
, asgiref
, pytz
, sqlparse
, pythonOlder
, withGdal ? false
}:

buildPythonPackage rec {
  pname = "Django";
  version = "3.1.5";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "2d78425ba74c7a1a74b196058b261b9733a8570782f4e2828974777ccca7edf7";
  };

  patches = stdenv.lib.optional withGdal
    (substituteAll {
      src = ./django_3_set_geos_gdal_lib.patch;
      geos = geos;
      gdal = gdal;
      extension = stdenv.hostPlatform.extensions.sharedLibrary;
    });

  propagatedBuildInputs = [
    asgiref
    pytz
    sqlparse
  ];

  # too complicated to setup
  doCheck = false;

  meta = with stdenv.lib; {
    description = "A high-level Python Web framework";
    homepage = "https://www.djangoproject.com/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ georgewhewell lsix ];
  };
}
