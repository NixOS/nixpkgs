{ lib, stdenv
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
  version = "3.2.5";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1kam3301jl53vm0mhflwwsqy5d7kb5dksmjanlaj7v7xakm5z81x";
  };

  patches = lib.optional withGdal
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

  meta = with lib; {
    description = "A high-level Python Web framework";
    homepage = "https://www.djangoproject.com/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ georgewhewell lsix ];
  };
}
